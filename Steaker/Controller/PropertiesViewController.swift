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
    // private przed var o ile nie jest uzywana ta zmienna w innym Controllerze
    /* private */ var propertiesBrain = PropertyBrain()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do storyboarda można wrzucić
        nextButton.layer.masksToBounds = true
        // To można wrzucić do metody viewDidLayoutSubviews
        nextButton.layer.cornerRadius = nextButton.frame.size.height / 5
        
        // UITableViewController ma metodę do ustawiania wysokości komórki - patrz linijka 42
        tableView.rowHeight = 60
        
        // Wyszczególniłbym osobną metodę typu `func setupTableView()`
        // K.cellIdentifier, też bym zmienił na to co pisałem w linijce 56
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
    }

    /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.frame.size.height / 5
    }
    */
    
    // MARK: - Table view data source

    // Najlepiej i tak byłoby zrobić, że w klasie PropertyCell.xib ustawić constrainty tak aby wysokośc komórki się sama wyliczała i usunąć tą metodę oraz linijkę 27. Domyślnie zwracane jest tutaj 'UITableView.automaticDimension' czyli apka sama wylicza jaka ma być wysokośc komórki. Jeżeli Ci zależy, żeby było dokładnie 60 no to wtedy możesz ustawić wysokośc labeli i constraintów w .xib tak aby sumarycznie dawały to 60.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertiesBrain.properties.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Zamiast K.cellIdentifier użyłbym albo `PropertyCell.description()` albo w Property cell stworzył statycznego leta z przypisanym stringiem K.PropertyCellIdentifier, żeby było wiadomo dokładnie jaki to jest identyfikator i do jakiej komórki przypisany
        
        // Nie używaj "! - force unwrap" bo może się zdażyć sytuacja, że wyniknie problem w tworzeniu tablicy i wyjebie aplikacje, lepiej dodać walidacje typu `guard let`
        /*
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as? PropertyCell else {
            return UITableViewCell()
        }
        */

        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! PropertyCell
        
        //Wyszcególnić można do osobnej funckji typu `cell.setupCell(with: PropertyBrain)` - czyli ta metoda w klasie PropertyCell dla kolejnych dwóch linijek, a nawet trzech, bo do PropertyBrain możesz dodać parametr tag i od razu masz większy model
        cell.label.text = propertiesBrain.properties[indexPath.row].title
//        cell.timeTextField.text = propertiesBrain.properties[indexPath.row].time
        cell.timeTextField.tag = indexPath.row
        
        cell.timeTextField.delegate = self

        return cell
    }
    
    /* tu poleciałeś na myczku, można zmienić na UIViewController z dodaną tablicą i przyciskiem na dole i się obędzie bez tych linijek */
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        // Ta linijka niepotrzebna bo domyślnie tak jest UIView() ustawione
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
            
            //New alert with title - czyżby komenty ze StackOverlow ? hahaha
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
        // kategorycznie nie moze być force - '!' - zamienić na guard let
        /*
         guard let text = textField.text, text.isEmpty else { return }
         */
        // Ten if jest niepotrzebny, bo jak jest walidacja w kodzie wyżej, czy text jest Empty to dla properties time i tak ma wartość defaultową 0 przypisaną
        if textField.text!.isEmpty {
            textField.text = 0.description
        }
        
        // nie ma potrzeby robić zmiennej row, wrzuć ją od razu do properties[]
        // Jeżeli uzyjesz tego guard let co napisałem wyżej to od razu na luzie możesz przypisać do time jako Int ten `text`
        let row = textField.tag
        //        propertiesBrain.properties[textField.tag].time = Int(text) ?? 0
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

