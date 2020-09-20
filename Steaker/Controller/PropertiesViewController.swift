//
//  propertiesViewController.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 20/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit

class PropertiesViewController: UITableViewController {
    @IBOutlet weak var cookButton: UIButton!
    
    var propertiesBrain = PropertyBrain()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cookButton.layer.masksToBounds = true
        cookButton.layer.cornerRadius = cookButton.frame.size.height / 5
        
        tableView.rowHeight = 60
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertiesBrain.properties.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! PropertyCell
        
        cell.label.text = propertiesBrain.properties[indexPath.row].title
        cell.timeTextField.text = propertiesBrain.properties[indexPath.row].time
        
        cell.timeTextField.tag = indexPath.row
        cell.timeTextField.delegate = self

        return cell
    }
    
    @IBAction func cookButtonPressed(_ sender: UIButton) {
        let conditionTime = Int(propertiesBrain.properties[0].time) ?? 0
        
        if conditionTime > 0 {
        performSegue(withIdentifier: K.segues.toCookingSegue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCooking" {
            let destinationVC = segue.destination as! CookingViewController
            destinationVC.highTemperatureTime = propertiesBrain.properties[0].time
        }
    }
    
}

//MARK: - TextField Delegate Methods

extension PropertiesViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "0"
        }
        
        let row = textField.tag
        propertiesBrain.properties[row].time = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
