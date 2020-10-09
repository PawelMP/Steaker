//
//  PropertyCell.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 20/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit

class PropertyCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        label.layer.masksToBounds = true
        label.layer.cornerRadius = label.frame.size.height / 5
        
        label.adjustsFontSizeToFitWidth = true
        timeTextField.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(with property: PropertyBrain, for indexPath: IndexPath) {
        label.text = property.properties[indexPath.row].title
        //        cell.timeTextField.text = propertiesBrain.properties[indexPath.row].time
        timeTextField.tag = indexPath.row
    }
    
}
