//
//  File.swift
//  NeuralNetworkV1
//
//  Created by Matan Rak on 04/01/2018.
//  Copyright © 2018 Matan Rak. All rights reserved.
//

import Foundation

class Network{
    
    
    var layers : [Layer] = []
    var inputVector : [Double]?
    var description : String { return layers.reduce(into: "", {string, layer in string += layer.visualDescription}) }
    
    
    init(_ structure : [Int]){
        
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
        
        print("Network: ")
        for layer in layers{
            print(layer.description)
        }
    }

    
    func getOutputLayer() -> Layer{
        return layers.first(where: {$0.type == Layer.LayerType.OUTPUT}) ?? layers.last!
    }
    
    
    func getOutput(_ input : [Double]) -> [Double]{
        
        var output : [Double] = []
        getOutputLayer().neurons.forEach{ neuron in output.append(neuron.getActivation()) }
        return output
    }
    
    
    func feedForward(_ inputVector: [Double]){
       
        self.inputVector = inputVector
        layers[0].feedForward()
    }
    
    
    func backProp(expectedVector : [Double]){
        
        var delta : [Double] = Array(repeating: 1, count: layers.count)
        
        var errorSum = 0
        
        for hiddenNeuron in getOutputLayer().getPreviousLayer().neurons{
            
            let errorSum = getOutputLayer().neurons.reduce(into: 0, {sum, neuron in sum += (hiddenNeuron.weights[neuron]! *  (expectedVector[neuron.id] - neuron.getActivation()))})
        
        }
        
        getOutputLayer().neurons.forEach{ neuron in

            let error = expectedVector[neuron.id] - neuron.getActivation()
            let delta = error * neuron.getActivation() * (1 - neuron.getActivation())
            
            print("error: ", error)
            
            for hiddenNeuron in neuron.layer.getPreviousLayer().neurons{
                let error = expectedVector[neuron.id] - hiddenNeuron.getActivation()
                hiddenNeuron.weights[neuron] = Utils.sigmoid(hiddenNeuron.getActivation() * error)
            }
        }
    }
    
    
    func train(input: [Double], expected : [Double]){
        
        feedForward(input)
        backProp(expectedVector: expected)
        /*
        getOutputLayer().neurons.forEach{ neuron in
            neuron.adjust(input: input, delta: expected[neuron.id] - neuron.getActivation())
            
            layers.forEach{ layer in
                if layer.isHidden(){
                    layer.neurons.forEach{ prevNeuron in
                        prevNeuron.adjust(input: input, delta: expected[neuron.id] - neuron.getActivation())
                    }
                }
            }
        }
 */
    }
    
}

