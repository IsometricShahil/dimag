local path = (...):gsub("Matrix", "")
local Class = require(path .. "utils.class")
local checks = require(path .. "utils.checks")
local random = require(path .. "utils.random")
local Matrix = Class()

function Matrix:new(rows, cols)
	self.data = {}
	
	if type(rows) == "table" then
		--A matrix-shaped data object was provided, copy from it
		local data = rows
		
		self.rows = #data
		self.cols = #data[1]
		
		for i = 1, self.rows do
			local row = {}
			for j = 1, self.cols do
				row[j] = data[i][j]
			end
			self.data[i] = row
		end
	else
		--Create a new matrix with random values between -1 and 1
		self.rows = rows
		self.cols = cols
	
		for i = 1, rows do
			local row = {}
			for j = 1, cols do
				row[j] = random.rand() * 2 - 1
			end
			self.data[i] = row
		end
	end
end

function Matrix.fromArray(arr)
	local data = {}
	for _, v in ipairs(arr) do
		table.insert(data, { v })
	end
	return Matrix(data)
end

function Matrix:toArray()
	local arr = {}
	for i = 1, self.rows do
		for j = 1, self.cols do
			table.insert(arr, self.data[i][j])
		end
	end
	return arr
end

function Matrix:add(v)
	if type(v) == "number" then
		for i = 1, self.rows do
			for j = 1, self.cols do
				self.data[i][j] = self.data[i][j] + v
			end
		end
	else
		for i = 1, self.rows do
			for j = 1, self.cols do
				self.data[i][j] = self.data[i][j] + v.data[i][j]
			end
		end
	end
	return self
end

function Matrix:mult(v)
	if type(v) == "number" then
		for i = 1, self.rows do
			for j = 1, self.cols do
				self.data[i][j] = self.data[i][j] * v
			end
		end
	else
		for i = 1, self.rows do
			for j = 1, self.cols do
				self.data[i][j] = self.data[i][j] * v.data[i][j]
			end
		end
	end
	return self
end

function Matrix:map(f, ...)
	for i = 1, self.rows do
		for j = 1, self.cols do
			self.data[i][j] = f(self.data[i][j], i, j, ...)
		end
	end
	return self
end

function Matrix:copy()
	return Matrix(self.data)
end

function Matrix.__mul(a, b)
	checks.equal(a.cols, b.rows, "Number of columns in A", "the number of rows in B")
	
	local result = Matrix(a.rows, b.cols)
	
	for i = 1, result.rows do
		for j = 1, result.cols do
			local sum = 0
			for k = 1, a.cols do
				sum = sum + a.data[i][k] * b.data[k][j]
			end
			result.data[i][j] = sum
		end
	end
	
	return result
end

function Matrix:__tostring()
	local str = ""
	for i = 1, self.rows do
		str = str .. "["
		for j = 1, self.cols do
			str = str .. " " .. self.data[i][j]
			if j ~= self.cols then
				str = str .. ","
			end
		end
		str = str.." ]\n"
	end
	return str
end

return Matrix