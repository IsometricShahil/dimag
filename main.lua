Object = require "libs.classic.classic"
lg = love.graphics

local PipeManager = require "PipeManager"
local Bird = require "bird"

local pipeManager
local birds, deadBirds

local populationSize = 350 --Birds per generation
local simsPerFrame = 1 --How many times love.update is looped per frame to speed up the game
local generationCount = 1

function love.load()
	--We need two arrays, one to hold the birds currently alive and one to keep track of the dead birds
	birds, deadBirds = {}, {}
	
	--Let there be birds!
	for i = 1, populationSize do
		birds[i] = Bird(100, lg.getHeight() / 2)
	end
	
	pipeManager = PipeManager()
	lg.setBackgroundColor(113 / 255, 197 / 255, 207 / 255)
	lg.setNewFont(14)
end

function love.draw()
	pipeManager:draw()
	
	for _, bird in ipairs(birds) do
		bird:draw()
	end
	
	local msg = ("Generation: %d\nSpeed: %dX\nPopulation Size: %d"):format(generationCount, simsPerFrame, populationSize)
	
	lg.setColor(0, 0, 0)
	lg.print(msg, 10, 10)
end

function love.update(dt)
	for i = 1, simsPerFrame do
		pipeManager:update(dt)
		
		for _, bird in ipairs(birds) do
			--Let the AI think and jump if it deems neccessary
			bird:think(pipeManager.pipes)
			
			--Do regular flappy bird stuff
			bird:update(dt)
			bird:checkCollision(pipeManager.pipes)
		end
		
		for i = #birds, 1, -1 do
			if birds[i].dead then
				--The dead birds must be kept track of so we can pick the best one from them at the end of a generation
				table.insert(deadBirds, table.remove(birds, i))
			end
		end
		
		--All birds are dead?
		if #birds == 0 then
			--Let there be birds... again
			nextGen()
		end
	end
end

function love.mousemoved(x, y)
	simsPerFrame = math.floor((x / lg.getWidth())*10)
end

--Find and return the best bird based on fitness
function pickBest()
	local best = nil
	local bestFitness = 0
	
	--Notice how deadBirds is used here as when this function is called all the birds are dead
	for _, bird in ipairs(deadBirds) do
		if bird.fitness > bestFitness then
			best = bird
			bestFitness = bird.fitness
		end
	end
	
	return best
end

--Advance the generation
function nextGen()
	birds = {} --Clearing this is probably not needed tbh
	
	--Step 1. Pick the best bird
	local best = pickBest()
	
	for i = 1, populationSize do
		--Step 2. Copy it's brain (Crossover is not implemented yet, maybe in the future)
		--Step 3. Mutate the best brain with a rate of 10% for each new child bird, potentially creating some better birds
		local b = best.brain:copy():mutate(.1)
		birds[i] = Bird(100, lg.getHeight() / 2, b)
	end
	
	deadBirds = {} --Clear the saved birds array
	pipeManager = PipeManager() --Reset pipeManager
	
	generationCount = generationCount + 1
end
