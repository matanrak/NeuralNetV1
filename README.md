# NeuralNetV1
My first attempt at neural network (and a very simple one at that).

In it's current form, I use it to determine how much a user will like / dislike a combination of genres (cases).
To build a network you need to specifi it's structure. 
In this example the hidden layer has 4 neurons and the output layer has 2.

## Constructing the network:

`var network = Network(structure: [4, 2])`



## Training the network
To train the network you enter the input and expected output:

`network.train(input: [0, 1, 1, 0], expected: [0])`

Then get the result for an intput like so: 

`network.getOutput([0, 0, 1, 0]))`



## Example:

#### Inputs: (each ran 10,000 times):
- input: [1, 0, 0, 0] / expected:  [1, 0]]
- input: [0, 0, 1, 0] / expected:  [0, 1]]
- input: [0, 1, 1, 0] / expected:  [0, 1]]
- input: [1, 0, 0, 1] / expected:  [1, 0]]
    
#### Outputs:
- input: [1, 0, 0, 0] -> [0.9989, 0.0010] 
- input: [0, 0, 1, 0] -> [0.0005, 0.9991]
- input: [0, 1, 1, 0] -> [0.0004, 0.9996] 
- input: [1, 1, 1, 0] -> [0.2811, 0.7739]
- input: [0, 1, 1, 1] -> [0.0140, 0.9854]



As you can see it works, it's not that smart but it works.
In the first, second and third outputs it was pretty sure about the user's reaction because it was trained exactly for those cases,
BUT when faced with input #4 it reached a minor set back, it knows the user hates the two center cases, but also like the first case.
Ultimately due to the fact that it was trained more to hate the inner two cases than to like the first case it thinks the user will most likely dislike it.
Output 5, like outputs 1-3 makes alot of sense, it thinks the user is more likely the dislike the input becauses it'ss trained to hate the inner cases.
