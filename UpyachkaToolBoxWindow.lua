UpyachkaToolBox.Settings.UI = {}
UpyachkaToolBox.Settings.UI.Position = {}
UpyachkaToolBox.Settings.UI.Position.Actual = {}
UpyachkaToolBox.Settings.UI.Position.Default = {
    offsetX = 33,
    offsetY = 33
}

UpyachkaToolBox.UI = {}

-- Count of stolen items. TODO other place
local stolenItemsCount = 0


local function countStolenItems()
    local bagCache = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
    stolenItemsCount = 0
    for key, data in pairs(bagCache) do
        if (data.stolen) then
            stolenItemsCount = stolenItemsCount + data.stackCount
        end
    end
end

local function handleItemIfStolen(bagId, slotId, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange)
    countStolenItems()
end

EVENT_MANAGER:RegisterForEvent(UpyachkaToolBox.name .. "_stolenItemHandler", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, handleItemIfStolen)


local function checkPostition(position, default)
    if position.offsetX == nil then
        position.offsetX = defaultPosition.offsetX
    end
    if position.offsetY == nil then
        position.offsetY = defaultPosition.offsetY
    end
end

function UpyachkaToolBox.UI.createFloatingWindow()
    -- Load settings for window
    UpyachkaToolBox.Settings.UI = ZO_SavedVars:New("UpyachkaToolBoxWindowSettings", 1, nil, UpyachkaToolBox.Settings.UI)

    local padding = 11
    UpyachkaToolBox.UI.Window = UpyachkaUiFactory.createShadowWindow("UpyachkaToolBoxWindow", padding)
    local window = UpyachkaToolBox.UI.Window.Root

    local defaultPosition = UpyachkaToolBox.Settings.UI.Position.Default
    local position = UpyachkaToolBox.Settings.UI.Position.Actual
    checkPostition(position, defaultPosition)

    window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, position.offsetX, position.offsetY)

    UpyachkaToolBox.UI.Window.Backdrop:SetMovable(true)
    UpyachkaToolBox.UI.Window.Root:SetMovable(true)
    local function onMoveStop(self)
        local position = UpyachkaToolBox.Settings.UI.Position.Actual
        position.offsetX = self:GetLeft()
        position.offsetY = self:GetTop()
    end

    window:SetHandler("OnMoveStop", onMoveStop)

    local container = UpyachkaUiTools.getContainer(UpyachkaToolBox.UI.Window)
    UpyachkaToolBox.UI.Window.PositionLabel = UpyachkaUiFactory.createNormalLabel("PositionLabel", container)
    local positionLabel = UpyachkaToolBox.UI.Window.PositionLabel
    positionLabel:SetText("Position")
    positionLabel:SetAnchor(TOPLEFT, container, TOPLEFT, 0, 0)

    UpyachkaToolBox.UI.Window.SpeedLabel = UpyachkaUiFactory.createNormalLabel("SpeedLabel", container)
    local speedLabel = UpyachkaToolBox.UI.Window.SpeedLabel
    speedLabel:SetText("Speed")
    speedLabel:SetAnchor(TOPLEFT, positionLabel, BOTTOMLEFT, 0, 0)

    UpyachkaToolBox.UI.Window.ThiefLabel = UpyachkaUiFactory.createNormalLabel("ThiefLabel", container)
    UpyachkaToolBox.UI.Window.ThiefLabel:SetAnchor(TOPLEFT, speedLabel, BOTTOMLEFT, 0, 0)

    countStolenItems()
end


local function onPlayerCheckSpeed()
    UpyachkaToolBox.Measurements.Speed.onMeasure()
    local storage = UpyachkaToolBox.Measurements.PositionsStorage
    local position = storage:get(1)
    -- format for coordinates output.
    local f = "%.2f"
    local positionString
    if position ~= nil then
        positionString = "X: " .. string.format(f, position.x) .. " Y: " .. string.format(f, position.y) .. " Z: " .. string.format(f, position.z)
    else
        positionString = "Position calculating..."
    end
    UpyachkaToolBox.UI.Window.PositionLabel:SetText(positionString)
    local speed = UpyachkaToolBox.Measurements.Speed.calculate()
    local speedString = tonumber(string.format("%.2f", speed))
    UpyachkaToolBox.UI.Window.SpeedLabel:SetText("Speed: " .. speedString)

    -- TODO separate callback
    local thiefLabel = UpyachkaToolBox.UI.Window.ThiefLabel
    local limit, sold, _ = GetFenceSellTransactionInfo()
    thiefLabel:SetText(string.format("Fence: %d + (%d) / %d", sold, stolenItemsCount, limit))
end

EVENT_MANAGER:RegisterForUpdate(UpyachkaToolBox.name, UpyachkaToolBox.Settings.Measurements.Interval, onPlayerCheckSpeed)

-- Check that compass visible and follows by its state.
function hideWithCompass()
    if ZO_CompassFrame and UpyachkaToolBox.UI.Window then
        UpyachkaToolBox.UI.Window.Root:SetHidden(ZO_CompassFrame:IsHidden())
    end
end

EVENT_MANAGER:RegisterForUpdate(UpyachkaToolBox.name .. "VisibilityHandler", 100, hideWithCompass)