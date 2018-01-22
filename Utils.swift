//
//  Utils.swift
//  NeuralNetworkV1
//
//  Created by Matan Rak on 21/01/2018.
//  Copyright © 2018 Matan Rak. All rights reserved.
//

import Foundation

class Utils{
    
    
    public static func sigmoid(_ i: Double) -> Double {
        return 1.0 / (1.0 + exp(-i))
    }
    
    
    
}
