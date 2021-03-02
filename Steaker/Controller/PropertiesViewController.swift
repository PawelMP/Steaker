//
//  propertiesViewController.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 20/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit

class PropertiesViewController: UITableViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    
    private var propertiesBrain = PropertyFactory()
    private var currentTextField: UITextField?
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.frame.size.height / 5
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: PropertyCell.cellNibName, bundle: nil), forCellReuseIdentifier: PropertyCell.cellIdentifier)
        tableView.delaysContentTouches = false
    }
    
    // MARK: - UI action methods
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if let currentTextField = currentTextField {
            currentTextField.resignFirstResponder()
        }
        sender.alpha = 1
        
        let highTempTime = propertiesBrain.getNumber(forIndex: 0)
        let highTempTurns = propertiesBrain.getNumber(forIndex: 1)
        
        if highTempTime > 0 && highTempTurns > 0 {
            performSegue(withIdentifier: K.segues.cookingSegue, sender: self)
        } else {
            let alert = Alert()
            alert.createAlert(title: K.Content.SettingsGreaterThanZero, viewController: self)
        }
    }

    @IBAction func nextButtonTouched(_ sender: UIButton) {
        sender.alpha = 0.5
    }
    
    @IBAction func nextButtonExit(_ sender: UIButton) {
        sender.alpha = 1
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? CookingViewController,  segue.identifier == K.segues.cookingSegue {
            destinationVC.propertiesBrain = propertiesBrain
        }
        
    }
}

// MARK: - Table view data source

extension PropertiesViewController  {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertiesBrain.properties.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PropertyCell.cellIdentifier, for: indexPath) as? PropertyCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(with: propertiesBrain, for: indexPath)
        cell.timeTextField.delegate = self
        
        return cell
    }
}

// MARK: - Table view delegate

extension PropertiesViewController {
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        return footerView
    }
}

// MARK: - TextField Delegate Methods

extension PropertiesViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = nil
        textField.placeholder = 0.description
        currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            textField.text = 0.description
            return
        }
        propertiesBrain.setNumber(with: Int(text), forIndex: textField.tag)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

