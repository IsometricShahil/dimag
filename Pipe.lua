--The Pipe class is pretty straight forward

local Pipe = Object:extend()

function Pipe:new(x, w, top, gap)
	self.x = x
	self.width = w
	self.top = top
	self.bottom = gap + top
end

function Pipe:draw()
	local x1, y1, w1, h1, x2, y2, w2, h2 = self:getRects()
	lg.rectangle("fill", x1, y1, w1, h1)
	lg.rectangle("fill", x2, y2, w2, h2)
end

function Pipe:getRects()
	return self.x, 0, self.width, self.top,
	       self.x, self.bottom , self.width, lg.getHeight() - self.bottom
end

function Pipe:move(amount)
	self.x = self.x - amount
end

function Pipe:isOffscreen()
	return self.x + self.width < 0
end

return Pipe