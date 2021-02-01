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
    
    override func viewWillAppear(_ animated: Bool) {
        setupTableView()
    }
    
    private func setupTableView() {
        let backgroundImage = UIImage(named: "Background")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = UIImageView(image: backgroundImage)
    }
    
    // MARK: - SwipeTable update method
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.steakItems?[indexPath.row] {
            RealmManager.shared.remove(category: categoryForDeletion)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        if let currentSteak = selectedSteak {
            let alert = TextAlert()
            alert.createAlert(alertTitle: K.addSteakProperty, texfFieldPlaceholder: K.addNewProperty, selectedItem: currentSteak, tableView: tableView, topVC: self)
        }
    }
}

// MARK: - Table view data source
extension DetailsViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steakItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = steakItems?[indexPath.row].title ?? K.noAddedProperties
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
}
