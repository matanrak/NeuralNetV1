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
    
    var activation : Double{
        return getOutput()
    }
    
    var description : String { return String(describing: id) + ": " + String(describing: Double(round(activation * 100) / 100)) + " " + String(describing: weights.values.map({ Double(round($0 * 1000) / 1000)}))}

    
    public init(layer : Layer){
       
        self.layer = layer
        self.id = Neuron.generateID(layer: layer)
    }
    
    
    func getOutput() -> Double {
        
        if layer.isFirst(){
            return layer.network.inputVector![id]
        }
        
        let prevActivations = layer.previous.neurons.map { $0.getOutput() }
        let prevWeights = layer.previous.neurons.map { $0.weights[self] }
        
        //prevOut = dotProduct(prevActivations, prevWeights as! [Double])
       // print("prevActivations : " , prevActivations)
        
        return sigmoid(dotProduct(prevActivations, prevWeights as! [Double]) + bias)
    }
    
    
    func initiateWeights(){
        
        if !layer.isLast(){
            for next_neuron in layer.next.neurons{
                weights[next_neuron] = drand48()
            }
        }
    }
    
}
