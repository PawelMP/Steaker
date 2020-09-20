//
//  ViewController.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 20/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var previousCookingButton: UIButton!
    @IBOutlet weak var startCookingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //previousCookingButton.titleLabel?.adjustsFontForContentSizeCategory = true
        previousCookingButton.titleLabel?.adjustsFontSizeToFitWidth = true
        startCookingButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }

}

