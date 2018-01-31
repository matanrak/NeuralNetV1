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
    var cachedDeltas : [Neuron : Double] = [:]
    var inputVector : [Double]?
    var description : String { return layers.reduce(into: "", {string, layer in string += layer.visualDescription}) }
    public var outputLayer: Layer { get{ return layers.first(where: {$0.type == Layer.LayerType.OUTPUT}) ?? layers.last! } }
    public var learingRate = 0.1

    
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

        self.inputVector = input
        return getOutputLayer().neurons.lazy.map({$0.activation})
    }
    
    
    func backProp(expectedVector : [Double]){
        
        
        for layer in layers.lazy.filter({!$0.isFirst()}).map({$0}).reversed() {

            layer.neurons.forEach{ neuron in
                var delta : Double{
                    if layer.isLast(){
                        return expectedVector[neuron.id] - neuron.activation
                    }
                    return cachedDeltas[neuron] ?? 0 - neuron.activation
                }
                
               // print(layer.id, " - ", neuron.id, " -> ", delta )
                
                layer.previous.neurons.forEach{ prevNeuron in
                    cachedDeltas[prevNeuron] = Utils.sigmoid(Double((cachedDeltas[prevNeuron] ?? 0) + delta))
                }
                
                neuron.adjust(delta: delta)
            }
        }
    }
    
    private func applyBackProp(expectedVector : [Double]){
        
        for neuron in outputLayer.neurons{
            for from in neuron.layer.previous.neurons{
                
                let ak = neuron.activation
                let ai = from.activation
                let expected = expectedVector[neuron.id]
                let partialDerivative = -ak * (1 - ak) * ai * (expected - ak)
                let deltaWeight = -learingRate * partialDerivative
                let newWeight = from.weights[neuron]
                from.weights[neuron] = newWeight! + from.bias * deltaWeight
            }
        }
        
        for layer in layers.lazy.filter({!$0.isLast() && !$0.isFirst()}).map({$0}).reversed(){
            for neuron in layer.neurons{
                for from in neuron.layer.previous.neurons{
                    
                    let aj = neuron.activation
                    let ai = from.activation
                    
                    let sum : Double = neuron.layer.next.neurons.reduce(into: 0, { c, next in
                        let wjk = neuron.weights[next]!
                        let desiredOutput = expectedVector[next.id]
                        let ak = next.activation
                        c += (-(desiredOutput - ak) * ak * (1 - ak) * wjk)
                    })
                    
                    let deltaWeight = -learingRate * (aj * (1 - aj) * ai * sum)
                    from.weights[neuron] = from.weights[neuron]!  + deltaWeight + from.bias * deltaWeight
                }
            }
        }
    }
    
    
    func train(input: [Double], expected : [Double]){
        
        cachedDeltas.removeAll()
        self.inputVector = input
        
        applyBackProp(expectedVector: expected)
        
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

