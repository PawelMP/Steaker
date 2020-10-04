//
//  HistoryItem.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 24/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import Foundation
import RealmSwift

class HistoryItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: History.self, property: "items")
}
