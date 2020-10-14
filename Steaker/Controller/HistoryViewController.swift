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
        loadHistory()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = historyArray?[indexPath.row].name ?? "No previous steaks cooked yet"
        return cell
    }
    
    //FIXME: - usuń zbędne komentarze, chyba, że są dla Ciebie, żeby pamiętać co co robi :D
    //What to do when user selects row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segues.detailsSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Realm data source methods
    
    //Retrieve data from Realm
    func loadHistory() {
        //FIXME: - znowu osobna metoda w RealmManagere, która zwraca obiekt typu Results<History>
        historyArray = realm.objects(History.self).sorted(byKeyPath: "dateCreated", ascending: false)
    }
    
    //Save data to realm
    //FIXME: - do RealmManagera wrzucić
    func saveHistory(historyObject: Object) {
        do {
        try realm.write(){
            realm.add(historyObject)
            }
        } catch {
            print("Error saving history item to Realm, \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    //Preparation before navigation to another ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.detailsSegue {
            //FIXME: - masz tutaj znowu "!", poza tym masz if a potem if let, więć możesz te 3 problemy załatwić ładnym sposobem, patrz linijka 74 - będzie to wyglądać lepiej :)
            let destinationVC = segue.destination as! DetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedSteak = historyArray?[indexPath.row]
            }
        }
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow,
            let destinationVC = segue.destination as? DetailsViewController,
            segue.identifier == K.segues.detailsSegue {
            destinationVC.selectedSteak = historyArray?[indexPath.row]
        }
    }
    */
    
    // MARK: Navigation bar method
    // Add button on the navigation bar
    //FIXME: - Drugi raz tworzysz tutaj Alert z TextFieldami, więc tym bardziej trzeba dodać osobną klasę, która tworzy Ci od razu te textfieldy, zaoszczędzi to w chuj kodu. Do dodawania akcji można stworzyć osobną fabrykę, bo widzę, że akcję różnią się od tamtego alertu.
    //FIXME: - Stringi do Constants
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //New alert with title
        let alert = UIAlertController(title: "Add new steak cooked to history", message: nil, preferredStyle: .alert)
        
        //Textfield for this alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new meat"
            alertTextField.autocapitalizationType = .sentences
            textField = alertTextField
        }
        
        //Press add button on the alert window
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
            
            let newHistoryItem = History()
            if textField.text?.isEmpty == false {
                newHistoryItem.name = textField.text!
                newHistoryItem.dateCreated = Date()
                self.saveHistory(historyObject: newHistoryItem)
            }
        }))
        
        //Press cancel button on the alert window
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (UIAlertAction) in
        }))
        
        //Present alert
        present(alert, animated: true)
    }

    // MARK: - SwipeTable update method
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.historyArray?[indexPath.row] {
            // Do RealmManagera wrzucić - opisane w DetailsViewControllerze - masz tutaj identyczną logikę jak w DetailsVC więc tym bardziej
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category context \(error)")
            }
        }
    }
    
}
