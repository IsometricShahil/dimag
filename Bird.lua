local NeuralNetwork = require("dimag").NeuralNetwork

local AABBCircleOverlap = require("libs.batteries.intersect").aabb_circle_overlap
--Will be used to check for collision between birds and pipes

local Bird = Object:extend()

local gravity = 500

function Bird:new(x, y, brain)
	self.x = x
	self.y = y
	self.radius = 16
	self.velY = 0
	self.color = {}
	
	for i = 1, 3 do --Give it a random color
		self.color[i] = love.math.random()
	end
	
	self.brain = brain or NeuralNetwork(5, { 8 }, 1)
	--If no brain is given in constructor, create a new brain with 5 inputs, 1 hidden layer with 8 hidden neurons and 1 output
	
	self.fitness = 0
	--This will indicate how well the bird is doing
end

function Bird:draw()
	self.color[4] = .6
	lg.setColor(self.color)
	lg.circle("fill", self.x, self.y, self.radius)
	
	self.color[4] = 1
	lg.setColor(self.color)
	lg.circle("line", self.x, self.y, self.radius)
end

function Bird:update(dt)
	self.y = self.y + self.velY * dt
	self.velY = self.velY + gravity * dt
	
	self.fitness = self.fitness + 1
	--The longer the bird stays alive the fitter it is
end

function Bird:think(pipes)
	local closest = nil
	local closestDist = math.huge
	
	-- Find the closest pipe and it's distance to the bird
	for _, pipe in ipairs(pipes) do
		local d = (pipe.x + pipe.width) - self.x
		
		--Check for (d > 0) to ignore pipes that are past the bird already
		if d > 0 and d < closestDist then
			closestDist = d
			closest = pipe
		end
	end
	
	--Here are our five inputs
	local inputs = {
		self.y / lg.getHeight(),
		closest.x / lg.getWidth(),
		closest.top / lg.getHeight(),
		closestDist / lg.getWidth(),
		self.velY / 500
	}
	
	--Give an array of inputs, get an array of outputs
	--In this case the output array will have only one element actually..
	local output = self.brain:feedForward(inputs)
	
	--The output is value between 0 and 1, the bird jumps if the value is greater than 0.5
	if output[1] > 0.5 then
		self:jump()
	end
end

function Bird:jump()
	self.velY = -240
end

function Bird:checkCollision(pipes)
	for _, pipe in ipairs(pipes) do
		local x1, y1, w1, h1, x2, y2, w2, h2 = pipe:getRects()
		--The coords are transformed as needed by batteries.intersect
		x1, y1, w1, h1 = x1 + w1 * .5, y1 + h1 * .5, w1 * .5, h1 * .5
		x2, y2, w2, h2 = x2 + w2 * .5, y2 + h2 * .5, w2 * .5, h2 * .5
		
		if AABBCircleOverlap(x1, y1, w1, h1, self.x, self.y, self.radius) or
		   AABBCircleOverlap(x2, y2, w2, h2, self.x, self.y, self.radius) then
			self.dead = true
			return
		end
	end
	
	--Kill the bird if it hits the top or bottom of the screen
	if self.y > lg.getHeight() or self.y < 0 then
		self.dead = true
	end
end

return Bird