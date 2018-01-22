//
//  Neuron.swift
//  NeuralNetworkV1
//
//  Created by Matan Rak on 04/01/2018.
//  Copyright © 2018 Matan Rak. All rights reserved.
//

import Foundation


class Neuron : Hashable{
    
    static func ==(lhs: Neuron, rhs: Neuron) -> Bool { return (lhs.id == rhs.id) }
    
    static var id_count : Int = -1
    static var prev_layer : Int = -1
    static let global_bias = 1.0;
    static let learning_rate = 0.1;
    
    static func generateID(layer : Layer) -> Int {
        
        if prev_layer != layer.id{
            id_count = -1
            prev_layer = layer.id
        }
        
        id_count += 1
        return id_count
    }
    

    let id : Int
    let layer : Layer

    var weights : [Neuron : Double] = [:]
    var bias : Double = 0.0
    var hashValue: Int { return self.id }
    var input: Double = 0.5
    var description : String { return String(describing: id) + ": " + String(describing: getActivation()) }
        //" [" + String(describing: weights) + "]" }
    

    public init(layer : Layer){
        
        self.layer = layer
        self.id = Neuron.generateID(layer: layer)
    }
    
    
    func initiateWeights(){
        
        if !layer.isLast(){
            for next_neuron in layer.getNextLayer().neurons{
                weights[next_neuron] = drand48()
            }
        }
    }
    
    
    func adjust(input: [Double], delta : Double){
        
        if !layer.isFirst(){
            for prevNeuron in layer.getPreviousLayer().neurons{
                prevNeuron.weights[self] = Neuron.learning_rate * delta * prevNeuron.getActivation()
            }
        }
        
        bias = Neuron.learning_rate * delta
    }
    
    
    func getActivation() -> Double{
 
        if layer.isFirst(){
            return network.inputVector?[id] ?? -1
           // let sum  = layer.getPreviousLayer().neurons.reduce(0, {x, y in x + bias + input.reduce(0, {x2, y2 in x2 + y.weights[self]! * y.getActivation(input) * y2})})
          //  return Utils.sigmoid(sum)
        }
        
        return input
    }
    
    
}
