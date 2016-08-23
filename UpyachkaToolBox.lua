-- General namespace for ToolBox addon.
UpyachkaToolBox = {}
-- Addon name to use it as prefix and for check of EVENT_ADD_ON_LOADED.
UpyachkaToolBox.name = "UpyachkaToolBox"
-- Used to store settings of addon.
UpyachkaToolBox.Settings = {}

-- Intializes addon data.
function UpyachkaToolBox:Initialize()
    UpyachkaToolBox.UI.createFloatingWindow()
end

-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function UpyachkaToolBox.OnAddOnLoaded(event, addonName)
    -- Filter addon's by name.
    if addonName == UpyachkaToolBox.name then
        UpyachkaToolBox:Initialize()
        -- addon initialized. No more needs to listen event.
        EVENT_MANAGER:UnregisterForEvent(UpyachkaToolBox.name, EVENT_ADD_ON_LOADED)
    end
end

-- Registration for handling of ESO API events.
EVENT_MANAGER:RegisterForEvent(UpyachkaToolBox.name, EVENT_ADD_ON_LOADED, UpyachkaToolBox.OnAddOnLoaded)

local function parseItemDataList(cache, keyFilter)
    local keysList = {}
    for _, data in pairs(cache) do
        local key = keyFilter(data)
        if keysList[key] == nil then
            keysList[key] = data.slotIndex
        end
    end
    return keysList
end

-- Requests move of item from one bag to another.
local function moveItem(source, sourceSlot, target, targetSlot, quantity)
    if IsProtectedFunction("RequestMoveItem") then
        CallSecureProtected("RequestMoveItem", source, sourceSlot, target, targetSlot, quantity)
    else
        RequestMoveItem(source, sourceSlot, target, targetSlot, quantity)
    end
end

-- Stores stackable items from inventory to bank if they presented in bank
local function onBankOpened()
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
    local bankCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BANK)
    local function keyFilter(data)
        return data.itemInstanceId -- rawName also equals
    end

    local bankList = parseItemDataList(bankCache, keyFilter)
    for key, data in pairs(bagCache) do
        local bagSlot = data.slotIndex
        local itemKey = keyFilter(data)
        local bankSlot = bankList[itemKey]
        if bankSlot ~= nil then
            local bagStack, maxStack = GetSlotStackSize(BAG_BACKPACK, bagSlot)
            local bankStack, _ = GetSlotStackSize(BAG_BANK, bankSlot)
            local bankData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BANK, bankSlot)

            if bagStack + bankStack > maxStack then
                local quantity = maxStack - bankStack
                moveItem(BAG_BACKPACK, bagSlot, BAG_BANK, bankSlot, quantity)
                bagStack, _ = GetSlotStackSize(BAG_BACKPACK, bagSlot)
            end
            moveItem(BAG_BACKPACK, bagSlot, BAG_BANK, bankSlot, bagStack)
            return
        end
    end
end

EVENT_MANAGER:RegisterForEvent(UpyachkaToolBox.name .. "_storeToBankHandler", EVENT_OPEN_BANK, onBankOpened)
