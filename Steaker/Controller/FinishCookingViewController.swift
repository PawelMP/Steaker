//
//  FinishCookingViewController.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 01/03/2021.
//  Copyright © 2021 Paweł Pietrzyk. All rights reserved.
//

import UIKit

class FinishCookingViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var noteTextfield: UITextField!
    
    var propertiesBrain = PropertyFactory()
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true 
    }
    
    // MARK: - UI action methods
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let text = nameTextfield.text, !text.isEmpty {
            saveCookingDetails(text: text)
            self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            let alert = Alert()
            alert.createAlert(title: K.Content.EnterNameOfSteak, viewController: self)
        }
    }
    
    func saveCookingDetails (text: String) {
        let history = RealmManager.shared.saveHistory(text: text)
        
        for index in (0...3).reversed() {
            RealmManager.shared.saveHistoryItem(currentSteak: history, text: self.propertiesBrain.properties[index].title + self.propertiesBrain.properties[index].number.description)
        }
        
        if let note = noteTextfield.text, !note.isEmpty {
            RealmManager.shared.saveHistoryItem(currentSteak: history, text: note)
        }
    }

}
