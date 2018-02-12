//
//  Utils.swift
//  NeuralNetworkV1
//
//  Created by Matan Rak on 21/01/2018.
//  Copyright © 2018 Matan Rak. All rights reserved.
//

import Foundation
import Accelerate


func sigmoid(_ i: Double) -> Double {
    return 1.0 / (1.0 + exp(-i))
}
    
    
// Thanks to Davecom from Github for this
// awesome function that helped me out a-lot
func dotProduct(_ vec1: [Double], _ vec2: [Double]) -> Double {
    var answer: Double = 0.0
    vDSP_dotprD(vec1, 1, vec2, 1, &answer, vDSP_Length(vec1.count))
    return answer
}


// Thanks to Davecom from Github for this
// awesome function that helped me out a-lot
func derivativeSigmoid(_ x: Double) -> Double {
    return sigmoid(x) * (1 - sigmoid(x))
}

