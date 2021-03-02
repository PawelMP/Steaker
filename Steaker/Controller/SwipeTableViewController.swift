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

    //MARK: - TableView data source Methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.Content.Cell, for: indexPath) as? SwipeTableViewCell else {
            return UITableViewCell()
        }
        self.tableView(cell, setupCellForRowAt: indexPath)
        return cell
    }
    
    func tableView(_ cell: SwipeTableViewCell, setupCellForRowAt indexPath: IndexPath) {
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.font = K.Design.Font.Copperplate
        cell.delegate = self
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: K.Content.Delete) { action, indexPath in
            self.updateModel(at: indexPath)
        }

        deleteAction.image = K.Design.Image.Delete
    
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

