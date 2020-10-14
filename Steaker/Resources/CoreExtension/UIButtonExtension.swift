//
//  UIButtonExtension.swift
//  Steaker
//
//  Created by mwagner on 14/10/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit

enum CookButtonType: Int {
    case lowTemeprature
    case hightTemperature
    case `default`
}

extension UIButton {
    var cookButtonType: CookButtonType {
        return .default
    }
}
