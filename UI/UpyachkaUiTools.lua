-- Used to help with configuration of UI.
UpyachkaUiTools = {}

-- Returns content wrapper for any window
function UpyachkaUiTools.getContainer(widget)
    local container = widget.Container
    -- Check badrop and use it as parent if its exists
    if container == nil then container = widget end
    return container
end
