local Pipe = require "Pipe"

local PipeManager = Object:extend()

local width = 80
local interval = 2
local speed = 250
local gap = 125

function PipeManager:new()
	self.pipes = {}
	self.time = interval --Time starts at 'interval' so the first pipe is spawned without delay
end

function PipeManager:draw()
	lg.setColor(100 / 255, 160 / 255, 20 / 255)
	for _, pipe in ipairs(self.pipes) do
		pipe:draw()
	end
end

function PipeManager:update(dt)
	self.time = self.time + dt
	if self.time >= interval then
		local top = love.math.random(10, lg.getHeight() - gap)
		local pipe = Pipe(lg.getWidth(), width, top, gap)
		table.insert(self.pipes, pipe)
		self.time = 0
	end
	
	for _, pipe in ipairs(self.pipes) do
		pipe:move(speed * dt)
	end
	
	for i = #self.pipes, 1, -1 do
		if self.pipes[i]:isOffscreen() then
			table.remove(self.pipes, i)
		end
	end
end

return PipeManager