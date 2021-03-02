//
//  TextAlert.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 14/10/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit

class Alert {
    
    func createAlert(title: String, viewController: UIViewController) {
        //New alert with title
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        //Press ok button on the alert window
        alert.addAction(UIAlertAction(title: K.Content.OK, style: .cancel, handler: { (UIAlertAction) in
        }))
        
        //Present alert
        viewController.present(alert, animated: true)
    }
    
    func createAlertWithTextfield(title: String, placeholder: String, viewController: UIViewController, completionHandler: ((String) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let alertTextField = AlertTextField(alert: alert)
        let textField = alertTextField.initializeTextField(text: placeholder)
        
        alert.addAction(UIAlertAction(title: K.Content.Cancel, style: .destructive, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: K.Content.Add, style: .default, handler: { (UIAlertAction) in
            
            if let text = textField.text, !text.isEmpty {
                completionHandler?(text)
            }
        }))
        

        viewController.present(alert, animated: true)
    }
    
}

class AlertTextField {
    var alert: UIAlertController
    init(alert: UIAlertController) {
        self.alert = alert
    }
    
    //Create text field for alert
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
