//
//  RealmManager.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 14/10/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit
import RealmSwift

struct RealmManager {
    
    static let shared = RealmManager()
    
    private init() {
    }
    
    //Load History objects from Realm
    func loadHistory() -> Results<History> {
        return K.API.HISTORY_REF.sorted(byKeyPath: K.Content.DateCreated, ascending: false)
    }
    
    //Load HistoryItem objects from Realm
    func loadHistoryItems(selectedHistory: History) -> Results<HistoryItem> {
        return selectedHistory.items.sorted(byKeyPath: K.Content.DateCreated, ascending: false)
    }
    
    func saveCooking() {
        
    }
    
    //Save History object to Realm
    @discardableResult func saveHistory(text: String) -> History {
        let newHistory = History()
        do {
            try K.API.DB_REF.write(){
                newHistory.name = text
                newHistory.dateCreated = Date()
                K.API.DB_REF.add(newHistory)
            }
        } catch {
            print(error.localizedDescription)
        }
        return newHistory
    }
    
    //Save HistoryItem to Realm
    func saveHistoryItem(currentSteak: History, text: String) {
        do {
            try K.API.DB_REF.write() {
                let newHistoryItem = HistoryItem()
                newHistoryItem.title = text
                newHistoryItem.dateCreated = Date()
                currentSteak.items.append(newHistoryItem)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //Remove object from Realm
    func remove(category: Object) {
        do {
            try K.API.DB_REF.write {
                K.API.DB_REF.delete(category)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
