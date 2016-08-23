-- Window with background and internal wrapper for content.
BackdropWindow = {}

function BackdropWindow:new(id, root, backdrop, container)
    instance = { ID = id, Root = root, Backdrop = backdrop, Container = container }
    self.__index = self
    return setmetatable(instance, self)
end