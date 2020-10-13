//
//  Constants.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 20/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import Foundation

struct K {
    static let doneText = "Done"
    
    static let cookHighTemp = "Cook high temp!"
    static let cookLowTemp = "Cook low temp!"
    static let turnsLeftAtHighTemp = "Turns left at high temp:"
    static let turnsLeftAtLowTemp = "Turns left at low temp:"
    static let finishCooking = "Finish cooking"
    
    static let normalCell = "Cell"
    
    struct segues {
        static let historySegue = "toHistory"
        static let detailsSegue = "historyToDetails"
        static let propertiesSegue = "toProperties"
        static let cookingSegue = "toCooking"
    }
}
