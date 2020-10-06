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
    var propertiesBrain = PropertyBrain()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = nextButton.frame.size.height / 5
        
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
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
       return footerView
    }
    
    // MARK: - Button methods
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        sender.alpha = 1
        let highTempTime = Int(propertiesBrain.properties[0].time) ?? 0
        let highTempTurns = Int(propertiesBrain.properties[1].time) ?? 0
        
        if highTempTime > 0 && highTempTurns > 0 {
        performSegue(withIdentifier: K.segues.cookingSegue, sender: self)
        } else {
            
            //New alert with title
            let alert = UIAlertController(title: "High temperature settings must be greater than zero", message: nil, preferredStyle: .alert)
                
            //Press ok button on the alert window
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
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
            destinationVC.highTempTime = propertiesBrain.properties[0].time
            destinationVC.highTempTurns = propertiesBrain.properties[1].time
            destinationVC.lowTempTime = propertiesBrain.properties[2].time
            destinationVC.lowTempTurns = propertiesBrain.properties[3].time
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
        if textField.text!.isEmpty {
            textField.text = 0.description
        }
        
        let row = textField.tag
        propertiesBrain.properties[row].time = textField.text!
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//MARK: - TextField extension (add button)
extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: K.doneText, style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

