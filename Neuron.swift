//
//  Neuron.swift
//  NeuralNetworkV1
//
//  Created by Matan Rak on 04/01/2018.
//  Copyright © 2018 Matan Rak. All rights reserved.
//

import Foundation

public class Neuron : Hashable{
    
    public static func ==(left: Neuron, right: Neuron) -> Bool { return left.id == right.id && left.layer.id == right.layer.id }
    
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
   
    public var hashValue: Int { return self.id }
    var bias : Double = 0.0
    var delta : Double = 0.0
    var prevOut = 0.0
    
    var activation : Double{
        
        if layer.isFirst(){
            return layer.network.inputVector![id]
        }

        let prevActivations = layer.previous.neurons.map { $0.activation }
        let prevWeights = layer.previous.neurons.map { $0.weights[self] }

        let activation = dotProduct(v1: prevActivations, v2: prevWeights as! [Double])
        prevOut = activation
        
        return sigmoid(activation + bias)
    }
    
    var description : String { return String(describing: id) + ": " + String(describing: activation) + " " + String(describing: weights.values.map({$0}))}

    
    public init(layer : Layer){
       
        self.layer = layer
        self.id = Neuron.generateID(layer: layer)
    }
    
    
    func initiateWeights(){
        
        if !layer.isLast(){
            for next_neuron in layer.next.neurons{
                weights[next_neuron] = drand48()
            }
        }
    }
    
    
    func adjust(delta : Double){
        
        if !layer.isFirst(){

            //print("old w: ",  layer.getPreviousLayer().neurons[0].weights[self])
            layer.previous.neurons.forEach{ prevNeuron in
                prevNeuron.weights[self] =  prevNeuron.weights[self]! + Neuron.learning_rate * delta * prevNeuron.activation
            }
            //print("current w: ",  layer.getPreviousLayer().neurons[0].weights[self])
            
          //  bias = Neuron.learning_rate * delta
        }
    }
    
    
}
