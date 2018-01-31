//
//  main.swift
//  NeuralNetworkV1
//
//  Created by Matan Rak on 04/01/2018.
//  Copyright © 2018 Matan Rak. All rights reserved.
//

import Foundation

print("Running...")

var network = NeuralNetwork(structure: [4, 4, 2])

for _ in 0...4000{ network.train(input: [0, 0, 1, 0], expected: [0, 1]) }
for _ in 0...4000{ network.train(input: [0, 1, 1, 0], expected: [0, 1]) }
for _ in 0...4000{ network.train(input: [1, 0, 0, 1], expected: [1, 0]) }
for _ in 0...4000{ network.train(input: [1, 0, 0, 0], expected: [1, 0]) }


print ("Output 1: " , network.getOutput([0, 0, 1, 0]))
print ("Output 2: " , network.getOutput([0, 1, 1, 0]))
print ("Output 3: " , network.getOutput([1, 0, 0, 0]))
print ("Output 4: " , network.getOutput([1, 1, 1, 0]))
print ("Output 5: " , network.getOutput([0, 0, 0, 1]))

print(network.description)
