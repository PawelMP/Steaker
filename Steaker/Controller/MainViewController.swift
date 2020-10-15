//
//  ViewController.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 20/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var previousCookingButton: UIButton?
    @IBOutlet weak var startCookingButton: UIButton?

    @IBAction func startCookingButtonPressed(_ sender: UIButton) {
        sender.alpha = 1
    }
    
    @IBAction func startCookingButtonTouched(_ sender: UIButton) {
        sender.alpha = 0.5
    }
    
    @IBAction func startCookingButtonExit(_ sender: UIButton) {
        sender.alpha = 1
    }
    
    @IBAction func previousCookingButtonPressed(_ sender: UIButton) {
        sender.alpha = 1
    }
    
    @IBAction func previousCookingButtonTouched(_ sender: UIButton) {
        sender.alpha = 0.5
    }
    
    @IBAction func previousCookingButtonExit(_ sender: UIButton) {
        sender.alpha = 1
    }
}
