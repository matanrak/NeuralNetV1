//
//  File.swift
//  NeuralNetworkV1
//
//  Created by Matan Rak on 04/01/2018.
//  Copyright © 2018 Matan Rak. All rights reserved.
//

import Foundation

public class NeuralNetwork{
    
    public var layers : [Layer]!
    public var cachedDeltas : [Neuron : Double] = [:]
    public var outputLayer: Layer { get{ return layers.first(where: {$0.type == Layer.LayerType.OUTPUT}) ?? layers.last! } }
    public var description: String { get{ return layers.reduce(into: "", {string, layer in string += layer.visualDescription}) } }
    public var learningRate = 0.1
    public var inputVector : [Double]!
    
    public init(structure : [Int]){
        
        self.layers = []
        self.cachedDeltas = [:]
        
        for i in 0...(structure.count - 1){
            switch i {
            case 0:
                layers.append(Layer(network : self, size: structure[i], type: Layer.LayerType.INPUT))
            
            case structure.count - 1:
                layers.append(Layer(network : self, size: structure[i], type: Layer.LayerType.OUTPUT))
                
            default:
                layers.append(Layer(network : self, size: structure[i], type: Layer.LayerType.HIDDEN))
            }
        }
        
        layers.forEach{ layer in layer.neurons.forEach{ neuron in neuron.initiateWeights() }}
    }
    
    
    func getOutput(_ input : [Double]) -> [Double]{
        
        self.inputVector = input
        var r : [Double] = []
        
        for neuron in layers.last!.neurons{
            r.append(neuron.activation)
        }
    
       // return layers.last!.neurons.lazy.map({$0.activation})
        return r
    }
    
    
    
    func backProp(expectedVector : [Double]){
     
        layers.last!.neurons.forEach { neuron in neuron.delta = derivativeSigmoid(neuron.activation) * (expectedVector[neuron.id] - neuron.activation) }

        for layer in layers.lazy.filter({!$0.isLast()}).reversed() {
            layer.calculateDelta()
        }
        
        for layer in layers.lazy.filter({!$0.isFirst()}).reversed() {
            for neuron in layer.neurons {
                
             //   neuron.bias = learningRate * neuron.delta

                for prevNeuron in neuron.layer.previous.neurons {
                    prevNeuron.weights[neuron] = prevNeuron.weights[neuron]! + (learningRate * (prevNeuron.activation  * neuron.delta))
                }
            }
        }
    }
        

    public func train(input: [Double], expected : [Double]){
        
        inputVector = input
        
        cachedDeltas.removeAll()
        backProp(expectedVector: expected)
    }
    
}

