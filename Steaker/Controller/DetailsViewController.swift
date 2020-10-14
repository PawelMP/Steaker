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
    private var steakItems: Results<HistoryItem>?
    
    var selectedSteak: History? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var addPropertyButton: UIButton!
    
    //FIXME: - klasy typu override są niepotrzebne jak nie mają w sobie nic nowego - do usunięcia
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //FIXME: - Wydzielić do prywatnej metody typu setupTableView()
        let backgroundImage = UIImage(named: "Background.png")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        //FIXME: - self. jest zbędne, nie trzeba go tutaj pisać - do usunięcia
        self.tableView.backgroundView = UIImageView(image: backgroundImage)

        //FIXME: - 3 kolejne linijki ustawić w Storyboardzie
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.black
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
       
    }
    //FIXME: -  te metody są kompletnie zbędne, dodają tylko roboty bo jak klikniesz i przytzymasz przycisk i zjedziesz palcem trzymając poza ekran to zostanie na alfie 0.5, co wygląda jak bug. Możesz zostawić dla efektu ale jak już ma być to bym dopracował animację
    @IBAction func addNewButtonTouched(_ sender: UIButton) {
        sender.alpha = 0.5
    }
    
    @IBAction func addNewButtonExit(_ sender: UIButton) {
        sender.alpha = 1
    }
    
    //FIXME: - Wszystkie nadpisane metody z TableView wrzucałbym do extension od tego ViewControllera, żeby kod był bardziej czytelny i //MARK dałbym przed samym extension
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steakItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //FIXME: - Linijka poniżej jest już w SwipeTableViewController więc tutaj jest zbędna - do usunięcia
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        //FIXME: - String do Constants
        cell.textLabel?.text = steakItems?[indexPath.row].title ?? "No added properties yet"
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 0, alpha: 0.2)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    //MARK: - Realm data source methods
    func loadItems() {
        //FIXME: - String do Constants
        steakItems = selectedSteak?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    // MARK: - SwipeTable update method
    override func updateModel(at indexPath: IndexPath) {
        //FIXME: - Tutaj stworzyłbym Manager który zajmuje się logiką Realma i byłby to Singleton czyli na przykład
        // RealmManager.shared.remove(category: categoryForDeletion)
        // W środku by się wykonywał ten do {} catch {}
        // Służy to do tego, żeby odseparować logikę biblioteki od całości kodu i żeby ta logika, która jest w różnych miejsach była w jednym miejscu, w API późnije możesz robic na przykład cos takiego jak NetworkManager
        if let categoryForDeletion = self.steakItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category context \(error)")
            }
        }
    }
    
    //FIXME: - Tutaj jest lipa, lepiej stworzyć osobną klasę do tworzenia Alertów z TextFieldami niż tworzyć to w metodzie na kliknięcie
    @IBAction func addButtonPressed(_ sender: UIButton) {
        sender.alpha = 1
        var textField = UITextField()
        
        //New alert with title
        let alert = UIAlertController(title: "Add a steak property", message: nil, preferredStyle: .alert)
        
        //Textfield for this alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new property"
            alertTextField.autocapitalizationType = .sentences
            textField = alertTextField
        }
        
        //Press add button on the alert window
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
            
            if textField.text!.isEmpty == false {
                if let currentSteak = self.selectedSteak {
                    //FIXME: - To znowu do RealmManagera wrzucić trzeba
                   do {
                       try self.realm.write() {
                            let newPropertyItem = HistoryItem()
                            newPropertyItem.title = " " + textField.text! + " "
                        newPropertyItem.dateCreated = Date()
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
