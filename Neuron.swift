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
    
    static func generateID(layer : Layer) -> Int {
        
        if(prev_layer != layer.id){
            id_count = -1
            prev_layer = layer.id
        }
        
        id_count += 1
        return id_count
    }
    
    static let global_bias = 1.0;
    static let learning_rate = 0.1;
    
    private var bias : Double = 0.0
    
    public let layer : Layer
    public var weights : [Neuron : Double] = [:]
    public let id : Int
    public var hashValue: Int { return self.id }
    public var input: [Double] = []
    public var expected : Double = 0
    
    
    public init(layer : Layer){
        
        self.layer = layer
        self.id = Neuron.generateID(layer: layer)
    }
    
    public func initiateWeights(){
        
        if(layer.hasNextLayer()){
            for next_neuron in layer.getNextLayer().getNeurons(){
                weights[next_neuron] = drand48()
            }
        }
    }
    
    public func adjust(){
        
        if(layer.hasPreviousLayer()){
            for prev_neuron in layer.getPreviousLayer().getNeurons(){
                
                let delta = expected - getOutput()
                
                let new_weight = prev_neuron.weights[self]! + (Neuron.learning_rate * layer.getPreviousLayer().getInput()[prev_neuron.id] * delta)
                prev_neuron.weights[self] = new_weight
            }
        }
    }
    
    
    public func getOutput() -> Double{
        
        var sum = 0.0
        
        if(layer.hasPreviousLayer()){
            for prev_neuron in layer.getPreviousLayer().getNeurons(){
                sum += layer.getPreviousLayer().getInput()[prev_neuron.id] * prev_neuron.weights[self]!
            }
        }
        
        sum += Neuron.global_bias * bias
        
        return sigmoid(i : sum)
    }
    
    
    func sigmoid(i: Double) -> Double {
        return 1.0 / (1.0 + exp(-i))
    }
    
    
}
