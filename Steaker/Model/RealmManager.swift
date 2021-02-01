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
    let realm = try! Realm()
    
    private init() {
    }
    
    func loadHistory() -> Results<History> {
        return realm.objects(History.self).sorted(byKeyPath: K.dateCreated, ascending: false)
    }
    
    func loadHistoryItems(selectedHistory: History) -> Results<HistoryItem> {
        return selectedHistory.items.sorted(byKeyPath: K.dateCreated, ascending: false)
    }
    
    func saveCooking() {
        
    }
    
    @discardableResult func saveHistory(text: String) -> History {
        let newHistory = History()
        do {
            try realm.write(){
                newHistory.name = text
                newHistory.dateCreated = Date()
                realm.add(newHistory)
            }
        } catch {
            print("Error saving history item to Realm, \(error)")
        }
        return newHistory
    }
    
    func saveHistoryItem(currentSteak: History, text: String) {
        do {
            try self.realm.write() {
                let newHistoryItem = HistoryItem()
                newHistoryItem.title = text
                newHistoryItem.dateCreated = Date()
                currentSteak.items.append(newHistoryItem)
            }
        } catch {
            print("Error adding new category \(error)")
        }
    }
    
    func remove(category: Object) {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Error deleting category context \(error)")
        }
    }
    
}
