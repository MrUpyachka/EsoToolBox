-- General namespace for ToolBox addon.
UpyachkaToolBox = {}
-- Addon name to use it as prefix and for check of EVENT_ADD_ON_LOADED.
UpyachkaToolBox.name = "UpyachkaToolBox"
-- Used to store settings of addon.
UpyachkaToolBox.Settings = {}

-- Intializes addon data.
function UpyachkaToolBox:Initialize()
	UpyachkaToolBox.UI.createFloatingWindow()
	-- TODO ?
end
 
-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function UpyachkaToolBox.OnAddOnLoaded(event, addonName)
	-- Filter addon's by name.
	if addonName == UpyachkaToolBox.name then
		UpyachkaToolBox:Initialize()
	end
end

-- Registration for handling of ESO API events.
EVENT_MANAGER:RegisterForEvent(UpyachkaToolBox.name, EVENT_ADD_ON_LOADED, UpyachkaToolBox.OnAddOnLoaded)