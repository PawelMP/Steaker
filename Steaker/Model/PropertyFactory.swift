//
//  PropertyBrain.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 20/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import Foundation

struct PropertyFactory {
    var properties = [
        Property(title: " High temperature frying time per side [s] "),
        Property(title: " Amount of frying on the same side at high temp "),
        Property(title: " Low temperature frying time per side [s] "),
        Property(title: " Amount of frying on the same side at low temp ")
    ]
    
    //Set property number for IndexPath
    mutating func setNumber(with number: Int?, forIndex index: Int) {
        properties[index].number = number ?? 0
    }

    //Get property number for IndexPath
    func getNumber(forIndex index: Int) -> Int {
        return properties[index].number
    }
}
