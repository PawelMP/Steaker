//
//  DetailsViewController.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 20/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit
import RealmSwift

class DetailsViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var steakItems: Results<HistoryItem>?
    
    var selectedSteak: History? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var addPropertyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        addPropertyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let backgroundImage = UIImage(named: "Background.png")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = UIImageView(image: backgroundImage)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.black
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
       
//        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    @IBAction func addNewButtonTouched(_ sender: UIButton) {
        sender.alpha = 0.5
    }
    
    @IBAction func addNewButtonExit(_ sender: UIButton) {
        sender.alpha = 1
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steakItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = steakItems?[indexPath.row].title ?? "No added properties yet"
        cell.textLabel?.textColor = UIColor.white
        //cell.textLabel?.font = UIFont(name: "Copperplate", size: 20)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 0, alpha: 0.05)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
       return footerView
    }

    
    func loadItems() {
        steakItems = selectedSteak?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.steakItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category context \(error)")
            }
            //tableView.reloadData()
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        sender.alpha = 1
        var textField = UITextField()
        
        //New alert with title
        let alert = UIAlertController(title: "Add a steak property", message: "", preferredStyle: .alert)
        
        //Textfield for this alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new property"
            alertTextField.autocapitalizationType = .sentences
            textField = alertTextField
        }
        
        //Press add button on the alert window
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
            
            if textField.text != "" {
                if let currentSteak = self.selectedSteak {
                   do {
                       try self.realm.write() {
                            let newPropertyItem = HistoryItem()
                            newPropertyItem.title = " " + textField.text! + " "
                            currentSteak.items.append(newPropertyItem)
                       }
                   } catch {
                       print("Error adding new category \(error)")
                   }
                }
                self.tableView.reloadData()
            }
        }))
        
        //Press cancel button on the alert window
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (UIAlertAction) in
        }))
        
        //Present alert
        present(alert, animated: true)
        
    }
    
}
