//
//  Layer.swift
//  NeuralNetworkV1
//
//  Created by Matan Rak on 05/01/2018.
//  Copyright © 2018 Matan Rak. All rights reserved.
//

import Foundation

class Layer : Hashable{
    
    public enum LayerType { case INPUT, HIDDEN, OUTPUT }
    
    static func ==(lhs: Layer, rhs: Layer) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    static var id_count : Int = -1
    static func generateID() -> Int {
        id_count += 1
        return id_count
    }
    
    let id = generateID()
    let network : Network!
    var hashValue: Int { return self.id }
    var type : LayerType!
    var neurons : [Neuron] = []
    var description : String { return String(describing: id) + ": " + String(describing: type) +  " [" + String(describing: neurons.count) + "]" }
    var visualDescription : String { return neurons.reduce(into: "", {string, neuron in string += neuron.description + " \n"}) }
    
    
    init(network : Network, size : Int, type : LayerType){
        
        self.network = network
        self.type = type
        
        for _ in 0..<size{
            neurons.append(Neuron(layer: self))
        }
    }
    

    func feedForward(){
        if !isLast(){
            for nextNeuron in getNextLayer().neurons{
                nextNeuron.input = neurons.reduce(into: 0, { sum, localNeuron in sum += localNeuron.weights[nextNeuron]! * localNeuron.getActivation() })
            }
            
            getNextLayer().feedForward()
        }
    }
    
    
    func getOutput() -> Double{
        return neurons.reduce(into: 0, { sum, neuron in sum += neuron.getActivation()})
    }
    
    
    func isHidden() -> Bool{
        return type == .HIDDEN
    }
    
    
    func isFirst() -> Bool{
        return id == 0
    }
    
    
    func isLast() -> Bool{
        return id >= network.layers.count - 1
    }
    
    
    func isLastHiddenLayer() -> Bool{
        return network.layers.count - 2 > id
    }
    
    
    func getNextLayer() -> Layer{
        return network.layers[id + 1]
    }
    
    
    func getPreviousLayer() -> Layer{
        return network.layers[id - 1]
    }
    

    
}
