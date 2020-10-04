//
//  History.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 21/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import Foundation
import RealmSwift

class History: Object {
    @objc dynamic var name: String = ""
    let items = List<HistoryItem>()
    @objc dynamic var dateCreated: Date?
}
