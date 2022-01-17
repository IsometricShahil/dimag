# Class `NeuralNetwork`


## *@Constructor* `NeuralNetwork(input, hiddens, output)`
Creates a new neural network with `input` number of input neurons, `output` number of output neurons and `#hiddens` number of hidden layers with `hidden[n]` neurons in each layer. </br>
All weights and biases are randomized on network creation. </br>
For example, `NeuralNetwork(4, {5, 6}, 1)` will create a NeuralNetwork with 4 input neurons, 2 hidden layers with 5 neurons in the first and 6 neurons in the second layer and 1 output neuron. <br/>

## *@Static* `NeuralNetwork.deserialize(data)`
Static method that creates a new NeuralNetwork from given data.</br>

## *@Method* `NeuralNetwork:serialize()`
Serializes the network into json format and returns the json data that can be saved to disk and loaded by `.deserialize(data)` </br>

## *@Method* `NeuralNetwork:feedForward(inputArr)`
Takes in an array of numerical inputs and returns an array of numerical outputs.

## *@Method* `NeuralNetwork:mutate(rate)`
Mutate the weights and biases of the network with the given rate between 0 and 1. (A rate of 0.1 means 10% mutation rate)
Returns the network itself for possible chaining.

## *@Method* `NeuralNetwork:copy()`
Returns a copy of the network.