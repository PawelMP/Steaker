//
//  Constants.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 20/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import Foundation

struct K {
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "PropertyCell"
    
    struct segues {
        static let toHistorySegue = "toHistory"
        static let toDetailsSegue = "historyToDetails"
        static let toPropertiesSegue = "toProperties"
        static let toCookingSegue = "toCooking"
    }
}
