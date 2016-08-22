UpyachkaToolBox.Settings.UI = {}
UpyachkaToolBox.Settings.UI.Position = {}
UpyachkaToolBox.Settings.UI.Position.Actual = {}
UpyachkaToolBox.Settings.UI.Position.Default = {
    offsetX = 33,
    offsetY = 33
}

UpyachkaToolBox.UI = {}

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
    UpyachkaToolBox.UI.Window = UpyachkaUiFactory.createShadowWindow(id, padding)
    local window = UpyachkaToolBox.UI.Window.Container

    local defaultPosition = UpyachkaToolBox.Settings.UI.Position.Default
    local position = UpyachkaToolBox.Settings.UI.Position.Actual
    checkPostition(position, defaultPosition)

    window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, position.offsetX, position.offsetY)

    window:SetMovable(true)
    local function onMoveStop(self)
        local position = UpyachkaToolBox.Settings.UI.Position.Actual
        position.offsetX = self:GetLeft()
        position.offsetY = self:GetTop()
    end

    window:SetHandler("OnMoveStop", onMoveStop)

    local container = UpyachkaUiTools.getContainer(parent)
    UpyachkaToolBox.UI.Window.PositionLabel = UpyachkaUiFactory.createNormalLabel("PositionLabel", container)
    local positionLabel = UpyachkaToolBox.UI.Window.Label
    positionLabel:SetText("Position")
    positionLabel:SetAnchor(TOPLEFT, container, TOPLEFT, 0, 0)

    UpyachkaToolBox.UI.Window.SpeedLabel = UpyachkaUiFactory.createNormalLabel("SpeedLabel", container)
    local speedLabel = UpyachkaToolBox.UI.Window.SpeedLabel
    speedLabel:SetText("Speed")
    speedLabel:SetAnchor(TOPLEFT, positionLabel, BOTTOMLEFT, 0, 0)

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
end

EVENT_MANAGER:RegisterForUpdate(UpyachkaToolBox.name, UpyachkaToolBox.Settings.Measurements.Interval, onPlayerCheckSpeed)

-- Check that compass visible and follows by its state.
function hideWithCompass()
    if ZO_CompassFrame and UpyachkaToolBox.UI.Window then
        UpyachkaToolBox.UI.Window:SetHidden(ZO_CompassFrame:IsHidden())
    end
end

EVENT_MANAGER:RegisterForUpdate(UpyachkaToolBox.name .. "", 100, hideWithCompass)