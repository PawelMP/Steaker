//
//  PropertyCell.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 20/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit

class PropertyCell: UITableViewCell {
    
    class var cellIdentifier: String {
        return K.PropertyCell.cellIdentifier
    }
    
    class var cellNibName: String {
        return K.PropertyCell.cellNibName
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        label.layer.masksToBounds = true
        label.layer.cornerRadius = label.frame.size.height / 5
        
        label.adjustsFontSizeToFitWidth = true
        timeTextField.adjustsFontSizeToFitWidth = true
        timeTextField.addDoneButtonOnKeyboard()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(with property: PropertyFactory, for indexPath: IndexPath) {
        label.text = property.properties[indexPath.row].title
        timeTextField.tag = indexPath.row
    }
    
}
