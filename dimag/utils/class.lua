return function()
	local cls = { new = function() end }
	cls.__index = cls
	return setmetatable(cls, {__call = function(_, ...)
		local o = setmetatable({}, cls)
		o:new(...)
		return o
	end})
end