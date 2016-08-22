
-- Storage used to remember last positions of player.
PlayerPositionsStorage = {}
function PlayerPositionsStorage:new(positionsNumber)
	instance = {positionsLimit = positionsNumber, size = 0}
	self.__index = self
	return setmetatable(instance, self)
end
-- Saves position to storage.
function PlayerPositionsStorage:save(position)
	if self.size == 0 then
		-- initial case. Create first, save its index and total count.
		self.size = 1
		self[self.size] = position
		self.startIndex = 1
	elseif self.size == self.positionsLimit then
		-- Moving case. Remove first, increase index and add new position to the end.
		self[self.startIndex] = nil
		self[self.startIndex + self.size] = position
		self.startIndex = self.startIndex + 1
	else
		-- Speedup case. Increase size and add new position to the end.
		self.size = self.size + 1
		self[self.size] = position
	end
end

-- Returns position by index. Index starts from 1. First position is latest. Position with index equal to positionsLimit is oldest one.
function PlayerPositionsStorage:get(index)
	if self.size == nil then
		return {}
	else
		return self[self.startIndex + self.size - index]
	end
end
