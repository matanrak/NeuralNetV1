//
//  Layer.swift
//  NeuralNetworkV1
//
//  Created by Matan Rak on 05/01/2018.
//  Copyright © 2018 Matan Rak. All rights reserved.
//

import Foundation

class Layer : Hashable{
    
    static func ==(lhs: Layer, rhs: Layer) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    static var id_count : Int = -1
    static func generateID() -> Int {
        id_count += 1
        return id_count
    }
    
    private let size : Int
    private let network : Network
    private var neurons : [Neuron] = []
    private var input : [Double] = []
    
    public let id = generateID()
    public var hashValue: Int { return self.id }
    

    init(network : Network, size : Int){
        
        self.size = size
        self.network = network
        
        for _ in 0..<size{
            neurons.append(Neuron(layer: self))
        }
    }
    
    public func InitiateWeights(){
        for neuron in neurons{
            neuron.initiateWeights()
        }
    }
    
    public func setInput(input : [Double]){
        self.input = input
    }
    
    public func getNeurons() -> [Neuron]{
        return neurons
    }
    
    public func hasNextLayer() -> Bool{
        return network.getLayers().count > (id + 1)
    }
    
    public func hasPreviousLayer() -> Bool{
        return id > 0
    }

    public func isOutputlayer() -> Bool{
        return !hasNextLayer()
    }
    
    public func getNextLayer() -> Layer{
        return network.getLayers()[id + 1]
    }
    
    public func getPreviousLayer() -> Layer{
        return network.getLayers()[id - 1]
    }
    
    public func getSize() -> Int{
        return self.size
    }
    
    public func getInput() -> [Double]{
        return self.input
    }
    
    
    public func getOutput() -> [Double]{
        
        var output : [Double] = []
        
        for neuron in neurons{
            output.append(neuron.getOutput())
        }
        
        return output
    }
    
    
    public func adjust(expected : [Double]){
        
        for neuron in neurons{
            neuron.adjust()
        }
    }
    
    
}
