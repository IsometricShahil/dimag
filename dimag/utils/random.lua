local random = {}

if type(love) == "table" and type(love.math) == "table" then
	random.rand = love.math.random
	random.randNormal = love.math.randomNormal
else
	random.rand = math.random
	
	--TODO: Figure out how to implement this
	function random.randNormal(sd, mean)
		sd = sd or 1
		mean = mean or 0
		
		--Implementation goes here
	end
end

return random