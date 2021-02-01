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
    
    static let addNewSteakToHistory = "Add new steak cooked to history"
    static let dateCreated = "dateCreated"
    static let noAddedProperties = "No added properties yet"
    static let noCookedSteaks = "No previous steaks cooked yet"
    static let addNewProperty = "Add new property"
    static let addSteakProperty = "Add a steak property"
    static let questionAddMeatToHistory = "Do you want to add this meat to the history?"
    static let addMeatToHistory = "Add meat to the history"
    static let settingsGreaterThanZero = "High temperature settings must be greater than zero"
    
    static let add = "Add"
    static let yes = "Yes"
    static let no = "No"
    static let ok = "OK"
    static let cancel = "Cancel"
    static let delete = "Delete"
    static let deleteIcon = "delete-icon"
    static let name = "Name"
    static let notes = "Notes"
    
    static let fontCopperplate = "Copperplate"
}
