//
//  Constants.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 20/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

struct K {
    
    struct Design {
        struct Color {
            static let White = UIColor.white
            static let Clear = UIColor.clear
            static let LowAlpha = UIColor(white: 0, alpha: 0.2)
        }
        struct Image {
            static let HistoryItemsTableViewBackgroundImage = UIImage(named: "Background")
            static let HistoryItemsTableViewBackgroundImageView = UIImageView(image: HistoryItemsTableViewBackgroundImage)
            static let Delete = UIImage(named: "delete-icon")
        }
        struct Font {
            static let Copperplate = UIFont(name: "Copperplate", size: 20)
        }
    }
    
    struct Content {
        static let Add = "Add"
        static let Cancel = "Cancel"
        static let Done = "Done"
        static let OK = "OK"
        static let Delete = "Delete"
        
        static let AddNewSteakToHistory = "Add new steak to history"
        static let TurnsLeftAtHighTemp = "Turns left at high temp:"
        static let TurnsLeftAtLowTemp = "Turns left at low temp:"
        static let FinishCooking = "Finish cooking"
        
        static let DateCreated = "dateCreated"
        static let AddNewProperty = "Add new property"
        static let AddSteakProperty = "Add a steak property"
        static let SettingsGreaterThanZero = "High temperature settings must be greater than zero"
        static let EnterNameOfSteak = "You must enter the name of the steak"
        
        static let Cell = "Cell"
        
    }
    
    struct API {
        static let DB_REF = try! Realm()
        static let HISTORY_REF = DB_REF.objects(History.self)
    }
    
    struct Sound {
        static let Bell = "bell"
        static let wav = "wav"
    }
    
    struct segues {
        static let historySegue = "toHistory"
        static let detailsSegue = "historyToDetails"
        static let propertiesSegue = "toProperties"
        static let cookingSegue = "toCooking"
        static let finishSegue = "toFinishCooking"
    }
    
    struct PropertyCell {
        static let cellIdentifier = "ReusableCell"
        static let cellNibName = "PropertyCell"
    }

}
