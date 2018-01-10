# NeuralNetV1
My first attempt at neural network (and a very simple one at that)
It uses a form of collaborative filtering to assume the user's opinion on a combination of cases.

In it's current form, it is used to determine how much a user will like / dislike a combination of genres (cases).
To build a network you need to specifi it's structure. 
In this example the hidden layer has 4 neurons and the output layer has 2.

Constructing the network:

var network = Network(structure: [4, 2])



To train the network first input a set of neuron cases (i.e state):

network.setInput(input: [[0, 0, 1, 0]])

Then adjust according to the expected output, 
In this example I expect only the second (output) layers recives an expected output:

network.adjust(expected: [[], [0, 1]])



Example:

- Training data sets (each ran 10,000 times):
    input: [[1, 0, 0, 0]] / expected:  [[], [1, 0]]
    input: [[0, 0, 1, 0]] / expected:  [[], [0, 1]]
    input: [[0, 1, 1, 0]] / expected:  [[], [0, 1]]
    input: [[1, 0, 0, 1]] / expected:  [[], [1, 0]]
    
- Outputs: 
    input: [[1, 0, 0, 0]] --> [0.99894748955184687, 0.0010683111095385147] 
    input: [[0, 0, 1, 0]] --> [0.00056865048709197404, 0.99926272418182271]
    input: [[0, 1, 1, 0]] --> [0.00041189102698458688, 0.99968771720806238] 
    input: [[1, 1, 1, 0]] --> [0.28113961467317533, 0.77393785967805873]
    input: [[0, 1, 1, 1]] --> [0.014084724119351666, 0.98548390517500961]


As you can see it works, it's not that smart but it works.
In the first, second and third outputs it was pretty sure about the user's reaction because it was trained exactly for those cases,
BUT when faced with input #4 it reached a minor set back, it knows the user hates the two center cases, but also like the first case.
Ultimately due to the fact that it was trained more to hate the inner two cases than to like the first case it thinks the user will most likely dislike it.
Output 5, like outputs 1-3 makes alot of sense, it thinks the user is more likely the dislike the input becauses it'ss trained to hate the inner cases.
