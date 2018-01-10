//
//  File.swift
//  NeuralNetworkV1
//
//  Created by Matan Rak on 04/01/2018.
//  Copyright © 2018 Matan Rak. All rights reserved.
//

import Foundation

class Network{
    
    
    public var layers : [Layer] = []
    
    init(structure : [Int]){
        
        for i in structure{
            layers.append(Layer(network : self, size: i))
        }
        
        for layer in layers {
            layer.InitiateWeights()
        }
    }

    
    public func setInput(input : [[Double]]){
        
        for i in 0...(input.count - 1){
            layers[i].setInput(input: input[i])
        }
    }
    
    
    public func getLayers() -> [Layer]{
        return layers
    }
    
    
    public func getOutputLayer() -> Layer{
        return layers[layers.count - 1]
    }
    
    
    public func getOutput() -> [Double]{
        
        var output : [Double] = []
            
        for neuron in getOutputLayer().getNeurons(){
            output.append(neuron.getOutput())
        }
        
        return output
    }
    
    
    public func adjust(expected : [[Double]]){
        
        for layer in layers{
            if(expected[layer.id].count == layer.getNeurons().count){
                if(layer.hasPreviousLayer()){
                    for neuron in layer.getNeurons(){
                        neuron.expected = expected[layer.id][neuron.id]
                        neuron.adjust()
                    }
                }
            }
        }
    }
    
    
    
}

