//
//  Layer.swift
//  NeuralNetworkV1
//
//  Created by Matan Rak on 05/01/2018.
//  Copyright © 2018 Matan Rak. All rights reserved.
//

import Foundation

public class Layer : Hashable{
    
    public enum LayerType { case INPUT, HIDDEN, OUTPUT }
    
    public static func == (lhs: Layer, rhs: Layer) -> Bool { return (lhs.id == rhs.id) }
    
    static var id_count : Int = -1
    static func generateID() -> Int {
        id_count += 1
        return id_count
    }
    
    public var hashValue: Int { return self.id }
    let id = generateID()
    
    let network : NeuralNetwork!
    var type : LayerType!
    var neurons : [Neuron] = []
    
    var previous : Layer { return network.layers[id - 1] }
    var next : Layer { return network.layers[id + 1] }
    
    var description : String { return String(describing: id) + ": " + String(describing: type) +  " [" + String(describing: neurons.count) + "]" }
    var visualDescription : String { return neurons.reduce(into: "", {string, neuron in string += neuron.description + " \n"}) }
    
    
    init(network : NeuralNetwork, size : Int, type : LayerType){
        
        self.network = network
        self.type = type
        
        (0..<size).forEach{_ in neurons.append(Neuron(layer: self))}
    }
    
    
    func outputs(inputs: [Double]) -> [Double] {
        return neurons.map { $0.activation }
    }

    
    func calculateDelta(nextLayer: Layer? = nil, expected: [Double] = []){
        
        if type == LayerType.OUTPUT{
            neurons.forEach { neuron in neuron.delta = derivativeSigmoid(neuron.prevOut) * (expected[neuron.id] - neuron.activation) }
              //  neurons[n].delta = neurons[n].derivativeActivationFunction( neurons[n].inputCache) * (expected[n] - outputCache[n])
            return
        }
        
        for neuron in neurons{
            let nextWeights = neuron.weights.values.map{ $0 }
            let nextDeltas = nextLayer!.neurons.map { $0.delta }
            let sumOfWeightsXDeltas = dotProduct(v1: nextWeights, v2: nextDeltas)
            neuron.delta = derivativeSigmoid(neuron.prevOut) * sumOfWeightsXDeltas
        }
    }

    
    func isHidden() -> Bool{
        return type == .HIDDEN
    }
    
    
    func isFirst() -> Bool{
        return id == 0
    }
    
    
    func isLast() -> Bool{
        return id == network.layers.count - 1
    }
    
    
    func isLastHiddenLayer() -> Bool{
        return network.layers.count - 2 > id
    }
    
}
