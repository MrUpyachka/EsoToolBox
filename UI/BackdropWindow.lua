-- Window with background.
BackdropWindow = {}

function BackdropWindow:new(id, container, backdrop)
	instance = {ID = id, Container = container, Backdrop = backdrop}
	self.__index = self
	return setmetatable(instance, self)
end
