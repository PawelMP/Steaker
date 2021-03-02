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
            if let currentSteak = selectedSteak {
                steakItems = RealmManager.shared.loadHistoryItems(selectedHistory: currentSteak)
            }
        }
    }
    
    @IBOutlet weak var addPropertyButton: UIButton!
    
    // MARK: - View controller lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.backgroundView = K.Design.Image.HistoryItemsTableViewBackgroundImageView
        //Turn off delays of touch down gestures
        tableView.delaysContentTouches = false
    }
    
    // MARK: - UI action methods
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        sender.alpha = 1
        addProperty()
    }
    
    //Create alert for adding property to the steak history
    func addProperty() {
        if let currentSteak = selectedSteak {
            let alert = Alert()
            alert.createAlertWithTextfield(title: K.Content.AddSteakProperty, placeholder: K.Content.AddNewProperty, viewController: self, completionHandler: { name in
                RealmManager.shared.saveHistoryItem(currentSteak: currentSteak, text: name)
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func addButtonTouched(_ sender: UIButton) {
        sender.alpha = 0.5
    }
    
    @IBAction func addButtonExit(_ sender: UIButton) {
        sender.alpha = 1
    }
    
    // MARK: - SwipeTable update method
    //Delete history object when cell is swiped
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.steakItems?[indexPath.row] {
            RealmManager.shared.remove(category: categoryForDeletion)
        }
    }
    
}

// MARK: - Table view data source

extension DetailsViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steakItems?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //call parent class method
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = steakItems?[indexPath.row].title
        cell.textLabel?.textColor = K.Design.Color.White
        
        return cell
    }
}

// MARK: - Table view delegate

extension DetailsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = K.Design.Color.LowAlpha
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = K.Design.Color.Clear
        return footerView
    }
}

