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
    }
    
    // MARK: - Button methods
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        sender.alpha = 1
        let highTempTime = propertiesBrain.properties[0].number
        let highTempTurns = propertiesBrain.properties[1].number
        
        if highTempTime > 0 && highTempTurns > 0 {
        performSegue(withIdentifier: K.segues.cookingSegue, sender: self)
        } else {
            
            //New alert with title
            let alert = UIAlertController(title: K.settingsGreaterThanZero, message: nil, preferredStyle: .alert)
                
            //Press ok button on the alert window
            alert.addAction(UIAlertAction(title: K.ok, style: .cancel, handler: { (UIAlertAction) in
            }))
            
            //Present alert
            present(alert, animated: true)
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
        
        if segue.identifier == K.segues.cookingSegue {
            let destinationVC = segue.destination as! CookingViewController
            destinationVC.propertiesBrain = propertiesBrain
        }
    }
    
}

// MARK: - TextField Delegate Methods
extension PropertiesViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.placeholder = 0.description
        textField.addDoneButtonOnKeyboard()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text, !text.isEmpty else {
            textField.text = 0.description
            return
        }
        propertiesBrain.properties[textField.tag].number = Int(text) ?? 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        return footerView
    }
}
