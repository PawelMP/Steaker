//
//  HistoryViewController.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 20/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    private var historyArray: Results<History>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyArray = RealmManager.shared.loadHistory()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = historyArray?[indexPath.row].name ?? K.noCookedSteaks
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segues.detailsSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow,
            let destinationVC = segue.destination as? DetailsViewController,
            segue.identifier == K.segues.detailsSegue {
            destinationVC.selectedSteak = historyArray?[indexPath.row]
        }
    }
    
    // MARK: Navigation bar method
    //FIXME: - Drugi raz tworzysz tutaj Alert z TextFieldami, więc tym bardziej trzeba dodać osobną klasę, która tworzy Ci od razu te textfieldy, zaoszczędzi to w chuj kodu. Do dodawania akcji można stworzyć osobną fabrykę, bo widzę, że akcję różnią się od tamtego alertu.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: K.addNewSteakToHistory, message: nil, preferredStyle: .alert)
        let alertTextField = AlertTextField(alert: alert)
        let textField = alertTextField.initializeTextField(text: K.addNewProperty)
        
        alert.addAction(UIAlertAction(title: K.add, style: .default, handler: { (UIAlertAction) in
            
            if textField.text?.isEmpty == false {
                RealmManager.shared.saveHistory(text: textField.text!)
                self.tableView.reloadData()
            }
        }))
        
        alert.addAction(UIAlertAction(title: K.cancel, style: .destructive, handler: { (UIAlertAction) in
        }))
        
        present(alert, animated: true)
    }

    // MARK: - SwipeTable update method
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.historyArray?[indexPath.row] {
            RealmManager.shared.remove(category: categoryForDeletion)
        }
    }
    
}
