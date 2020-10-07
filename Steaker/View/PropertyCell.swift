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
        // Initialization code
        label.layer.masksToBounds = true
        label.layer.cornerRadius = label.frame.size.height / 5
        
        label.adjustsFontSizeToFitWidth = true
        timeTextField.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
/*
extension PropertyCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("HA")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}*/
