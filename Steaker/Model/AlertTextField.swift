//
//  TextField.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 14/10/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit

class AlertTextField {
    var alert: UIAlertController
    init(alert:UIAlertController) {
        self.alert = alert
    }
    
    func initializeTextField(text: String) -> UITextField {
        var textField = UITextField()
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = text
            alertTextField.autocapitalizationType = .sentences
            textField = alertTextField
        }
        return textField
    }
}
