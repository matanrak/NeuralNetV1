//
//  File.swift
//  NeuralNetworkV1
//
//  Created by Matan Rak on 04/01/2018.
//  Copyright © 2018 Matan Rak. All rights reserved.
//

import Foundation

public class NeuralNetwork{
    
    public var layers : [Layer]!
    public var cachedDeltas : [Neuron : Double] = [:]
    public var outputLayer: Layer { get{ return layers.first(where: {$0.type == Layer.LayerType.OUTPUT}) ?? layers.last! } }
    public var description: String { get{ return layers.reduce(into: "", {string, layer in string += layer.visualDescription}) } }
    public var learningRate = 0.01
    public var inputVector : [Double]!
    
    public init(structure : [Int]){
        
        self.layers = []
        self.cachedDeltas = [:]
        
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
    }
    
    
    public func getOutput(_ input : [Double]) -> [Double]{
        
        return layers.reduce(input) { $1.outputs(inputs: $0) }

        //return outputLayer.neurons.lazy.map({$0.})
    }
    
    
    
    func backProp(expectedVector : [Double]){
     
        layers.last!.calculateDelta(expected: expectedVector)

        for layer in layers.lazy.filter({!$0.isFirst() && !$0.isLast()}) {
            layer.calculateDelta(nextLayer: layers[layer.id + 1])
        }
        
        for layer in layers.lazy.filter({!$0.isFirst()}) {
            //prevNeuron.weights[self] =  prevNeuron.weights[self]! + Neuron.learning_rate * delta * prevNeuron.activation

            for neuron in layer.neurons {
                for prevNeuron in neuron.layer.previous.neurons {
                    prevNeuron.weights[neuron] = prevNeuron.weights[neuron]! + (learningRate * (prevNeuron.activation  * neuron.delta))
                    //neuron.bias = Neuron.learning_rate * neuron.delta
                }
            }
        }
    }
        

    /*
    func backPropoLD(expectedVector : [Double]){
        
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
                    //cachedDeltas[prevNeuron] = Utils.sigmoid(Double((cachedDeltas[prevNeuron] ?? 0) + delta))
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
                        let wjk = next.weights[neuron]
                        let desiredOutput = expectedVector[next.id]
                        let ak = next.activation
                        c += (-(desiredOutput - ak) * ak * (1 - ak) * wjk!)
                    })
                    
                    let deltaWeight = -learingRate * (aj * (1 - aj) * ai * sum)
                    from.weights[neuron] = from.weights[neuron]!  + deltaWeight + from.bias * deltaWeight
                }
            }
        }
    }
    
 
     public void applyBackpropagation(double expectedOutput[]) {
     
     int i = 0;
     for (Neuron n : outputLayer) {
     ArrayList<Connection> connections = n.getAllInConnections();
     for (Connection con : connections) {
     double ak = n.getOutput();
     double ai = con.leftNeuron.getOutput();
     double desiredOutput = expectedOutput[i];
     
     double partialDerivative = -ak * (1 - ak) * ai * (desiredOutput - ak);
     double deltaWeight = -learningRate * partialDerivative;
     double newWeight = con.getWeight() + deltaWeight;
     con.setDeltaWeight(deltaWeight);
     con.setWeight(newWeight + momentum * con.getPrevDeltaWeight());
     }
     i++;
     }
     
     // update weights for the hidden layer
     for (Neuron n : hiddenLayer) {
         ArrayList<Connection> connections = n.getAllInConnections();
         for (Connection con : connections) {
         double aj = n.getOutput();
         double ai = con.leftNeuron.getOutput();
         double sumKoutputs = 0;
         int j = 0;
             for (Neuron out_neu : outputLayer) {
                 double wjk = out_neu.getConnection(n.id).getWeight();
                 double desiredOutput = (double) expectedOutput[j];
                 double ak = out_neu.getOutput();
                 j++;
                 sumKoutputs = sumKoutputs + (-(desiredOutput - ak) * ak * (1 - ak) * wjk);
             }
     
         double partialDerivative = aj * (1 - aj) * ai * sumKoutputs;
         double deltaWeight = -learningRate * partialDerivative;
         double newWeight = con.getWeight() + deltaWeight;
         con.setDeltaWeight(deltaWeight);
         con.setWeight(newWeight + momentum * con.getPrevDeltaWeight());
         }
    }
}
 
    */
    
    public func train(input: [Double], expected : [Double]){
        
        inputVector = input
        cachedDeltas.removeAll()
        
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

