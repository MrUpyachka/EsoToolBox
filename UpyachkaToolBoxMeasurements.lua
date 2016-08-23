-- Measurement functionality for distance/speed.
UpyachkaToolBox.Measurements = {}
UpyachkaToolBox.Measurements.Speed = {}
--[[
    TODO list
    # Recalculate PositionsNumber after update of attribute which affects it .
    ]]--

-- For speed and other measurement.
UpyachkaToolBox.Settings.Measurements = {}
-- Interval to check speed and other moving parameters.
UpyachkaToolBox.Settings.Measurements.Interval = 200 -- in milliseconds.
-- Speed measurement time limit. Speed measure will be based on this observe interval.
UpyachkaToolBox.Settings.Measurements.SpeedTimeSpan = 1000 -- in milliseconds.
-- To make distance more understandable that 0.039, for example.
UpyachkaToolBox.Settings.Measurements.DistanceCoefficient = 1000000 -- TODO in points?.
-- To fix different scale on Z axis.
UpyachkaToolBox.Settings.Measurements.AltitudeCoefficient = 0.1
-- Count of remembered player position. For example: 5 positions for 1 second interval.
UpyachkaToolBox.Settings.Measurements.PositionsNumber = UpyachkaToolBox.Settings.Measurements.SpeedTimeSpan / UpyachkaToolBox.Settings.Measurements.Interval

-- Storage instance.
UpyachkaToolBox.Measurements.PositionsStorage = PlayerPositionsStorage:new(UpyachkaToolBox.Settings.Measurements.PositionsNumber)

function UpyachkaToolBox.Measurements.Speed.onMeasure()
    local px, py, pz = GetMapPlayerPosition("player")
    local storage = UpyachkaToolBox.Measurements.PositionsStorage
    local position = { x = px, y = py, z = pz }
    storage:save(position)
end

-- Distance between two points in 3D.
local function calculateDistance(firstPosition, secondPosition)
    dX = secondPosition.x - firstPosition.x
    dY = secondPosition.y - firstPosition.y
    dZ = secondPosition.z - firstPosition.z
    local c = UpyachkaToolBox.Settings.Measurements.AltitudeCoefficient
    -- TODO something with altitude difference?
    -- return math.sqrt(dX*dX + dY*dY + dZ*dZ*c*c )
    return math.sqrt(dX * dX + dY * dY)
end

local function calculateTotalDistance()
    local storage = UpyachkaToolBox.Measurements.PositionsStorage
    local totalDistance = 0
    if storage.size > 1 then -- more that one position remembered.
    for i = 1, storage.size - 1 do
        local firstPosition = storage:get(i)
        local secondPosition = storage:get(i + 1)
        local span = calculateDistance(firstPosition, secondPosition)
        -- d("Span: " .. span)
        totalDistance = totalDistance + span
    end
    end
    return totalDistance
end

function UpyachkaToolBox.Measurements.Speed.calculate()
    local totalDistance = calculateTotalDistance() * UpyachkaToolBox.Settings.Measurements.DistanceCoefficient
    return totalDistance / UpyachkaToolBox.Settings.Measurements.SpeedTimeSpan
end

local function updateAttribute(attributeName, value)
    switch(string.lower(attributeName)) {
        [string.lower("DistanceCoefficient")] = function() UpyachkaToolBox.Settings.Measurements.DistanceCoefficient = value end,
        [string.lower("Interval")] = function() UpyachkaToolBox.Settings.Measurements.Interval = value end,
        [string.lower("SpeedTimeSpan")] = function() UpyachkaToolBox.Settings.Measurements.SpeedTimeSpan = value end,
        default = function() d("Wrong measurement attribute: " + attributeName) end
    }
end
--[[
    Chat commands to update measurement attributes.
]] --
SLASH_COMMANDS["/measurement"] = updateAttribute