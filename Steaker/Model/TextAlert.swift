//
//  TextAlert.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 14/10/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit

class TextAlert {
    
    func createAlert(alertTitle: String, texfFieldPlaceholder: String, selectedItem: History ,tableView: UITableView, topVC: UIViewController) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a steak property", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new property"
            alertTextField.autocapitalizationType = .sentences
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
            
            if textField.text!.isEmpty == false {
                RealmManager.shared.saveHistoryItem(currentSteak: selectedItem, text: textField.text!)
                //self.realmMethod(self.textField)
                tableView.reloadData()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (UIAlertAction) in
        }))

        topVC.present(alert, animated: true)
    }
    
}
