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
    
    // MARK: - View controller lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        historyArray = RealmManager.shared.loadHistory()
    }
    
    // MARK: - Navigation
    //Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow,
            let destinationVC = segue.destination as? DetailsViewController,
            segue.identifier == K.segues.detailsSegue {
            destinationVC.selectedSteak = historyArray?[indexPath.row]
        }
    }
    
    // MARK: Navigation bar method
    //Add button on navigation bar pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        addSteak()
    }

    //Create alert for adding steak to the history
    func addSteak() {
        let alert = Alert()
        alert.createAlertWithTextfield(title: K.Content.AddNewSteakToHistory, placeholder: K.Content.AddNewProperty, viewController: self, completionHandler: { name in
            RealmManager.shared.saveHistory(text: name)
            self.tableView.reloadData()
        })
    }
    
    // MARK: - SwipeTable update method
    //Delete history object when cell is swiped
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.historyArray?[indexPath.row] {
            RealmManager.shared.remove(category: categoryForDeletion)
        }
    }
}

// MARK: - Table view data source
extension HistoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //call parent class method
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = historyArray?[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segues.detailsSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
