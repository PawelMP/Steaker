//
//  SwipeTableViewController.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 26/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    //FIXME: - Usuń metodę całą jak usuniesz rowHeight
    override func viewDidLoad() {
        super.viewDidLoad()
        //FIXME: - wrzuć to do metody heightForRowAt jak wcześniej pisałem
        tableView.rowHeight = 60.0
    }

    //MARK: - TableView data source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //FIXME: - guard let zamiast force unwrapa -> !
        let cell = tableView.dequeueReusableCell(withIdentifier: K.normalCell, for: indexPath) as! SwipeTableViewCell
        //FIXME: - dodałbym nową metode - patrz linijka 37
        //Dzięki tej metodzie możesz później w kolejnych klasach overridowac tylko ten setupCell i dopisując kolejne rzeczy :) a dodajesz tak jakby do dokumentacji kolejną metodę reużywalną
        //tableView(cell, setupCellForRowAt: indexPath)
        // Stringi fontów też wrzuć w Constants
        //Wielkości czcionek oraz inne stałe też jest lepiej wrzucić do prywatnej zmiennej na samej górze klasy i nazwać je typu private let cellFontSize: CGFloat = 20
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.font = UIFont(name: "Copperplate", size: 20)
        cell.delegate = self
        return cell
    }
    
    /*
    func tableView(_ cell: SwipeTableViewCell, setupCellForRowAt: IndexPath) {
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.font = UIFont(name: "Copperplate", size: 20)
        cell.delegate = self
    }
*/
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        //FIXME: - String do constants
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
        }

        //FIXME: - String do constants
        deleteAction.image = UIImage(named: "delete-icon")
    
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    //MARK: - Update Data Model
    func updateModel(at indexPath: IndexPath) {
    }
}

