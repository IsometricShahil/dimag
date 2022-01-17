local path = (...):gsub("NeuralNetwork", "")
local Class = require(path .. "utils.class")
local checks = require(path .. "utils.checks")
local random = require(path .. "utils.random")
local Matrix = require(path .. "Matrix")
local json = require(path .. "deps.json.json")

local function sigmoid(x)
	return 1 / ( 1 + math.exp(-x) )
end

local NeuralNetwork = Class()

function NeuralNetwork:new(input, hiddens, output)
	checks.type(input, "number", "NeuralNetwork", 1)
	checks.type(hiddens, "table", "NeuralNetwork", 2)
	checks.type(output, "number", "NeuralNetwork", 3)
	
	self.inputsCount = input
	self.hiddenCounts = hiddens
	self.outputCount = output
	
	self.weights = {}
	self.biases = {}
	
	table.insert(self.weights, Matrix(hiddens[1], input))
	table.insert(self.biases, Matrix(hiddens[1], 1))
	
	for i = 2, #hiddens do
		local weightMat = Matrix(hiddens[i], hiddens[i-1])
		table.insert(self.weights, weightMat)
		
		local biasMat = Matrix(hiddens[i], 1)
		table.insert(self.biases, Matrix(hiddens[i], 1))
	end
	
	table.insert(self.weights, Matrix(output, hiddens[#hiddens]))
	table.insert(self.biases, Matrix(output, 1))
	
	assert(#self.weights == #self.biases)
end

function NeuralNetwork.deserialize(data)
	local self = json.decode(data)
	setmetatable(self, NeuralNetwork)
	
	for i = 1, #self.weights do
		setmetatable(self.weights[i], Matrix)
		setmetatable(self.biases[i], Matrix)
	end
	
	return self
end

function NeuralNetwork:serialize()
	return json.encode(self)
end

function NeuralNetwork:feedForward(inputArr)
	checks.type(inputArr, "table", "NeuralNetwork:feedForward", 1)
	checks.equal(#inputArr, self.inputsCount, "Number of inputs", "the number of neurons in input layer")
	local inputs = Matrix.fromArray(inputArr)
	
	local res = self.weights[1] * inputs
	res:add(self.biases[1])
	res:map(sigmoid)
	
	for i = 2, #self.weights do
		res = self.weights[i] * res
		res:add(self.biases[i])
		res:map(sigmoid)
	end
	
	return res:toArray()
end

local function mutateFn(value, i, j, rate)
	if random.rand() < rate then
		return value + random.randNormal() * .5
	else
		return value
	end
end

function NeuralNetwork:mutate(rate)
	checks.type(rate, "number", "NeuralNetwork:mutate", 1)
	
	for i = 1, #self.weights do
		self.weights[i]:map(mutateFn, rate)
		self.biases[i]:map(mutateFn, rate)
	end
	return self
end

function NeuralNetwork:copy()
	local cp = setmetatable({}, NeuralNetwork)
	
	cp.inputsCount = self.inputsCount
	cp.hiddenCounts = self.hiddenCounts
	cp.outputCount = self.outputCount
	cp.weights = {}
	cp.biases = {}
	
	for i = 1, #self.weights do
		cp.weights[i] = self.weights[i]:copy()
		cp.biases[i] = self.biases[i]:copy()
	end
	
	return cp
end

return NeuralNetwork