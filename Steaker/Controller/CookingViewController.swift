//
//  CookingViewController.swift
//  Steaker
//
//  Created by Paweł Pietrzyk on 20/09/2020.
//  Copyright © 2020 Paweł Pietrzyk. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation


class CookingViewController: UIViewController{
    
    @IBOutlet weak var cookButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerProgressView: UIProgressView!
    @IBOutlet weak var turnsLeftLabel: UILabel!
    
    private var player: AVAudioPlayer!
    
    var propertiesBrain = PropertyFactory()
    
    private var timer = Timer()
    
    private var highTempTimeInt: Int = 0
    private var lowTempTimeInt: Int = 0
    
    private var turnsCounter = 0
    
    let realm = try! Realm()
    private var cookingStage: CookButtonType = .highTemperature
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    func setupController() {
        cookButton.titleLabel?.textAlignment = .center
        cookButton.titleLabel?.adjustsFontSizeToFitWidth = true
        updateTurnsLabel(turns: propertiesBrain.properties[1].number)
        
        timerLabel.text = propertiesBrain.getNumber(forIndex: 0).description
        timerProgressView.progress = 0
        
        highTempTimeInt = propertiesBrain.getNumber(forIndex: 0)
        lowTempTimeInt = propertiesBrain.getNumber(forIndex: 2)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? FinishCookingViewController,  segue.identifier == K.segues.finishSegue {
            destinationVC.propertiesBrain = propertiesBrain
        }
        
    }
    
    // MARK: - UI action methods
    
    @IBAction func cookButtonPressed(_ sender: UIButton) {
        
        switch cookingStage {
        case .highTemperature:
            setupCook(sender,
                      title: propertiesBrain.getNumber(forIndex: 0).description,
                      selector: #selector(updateTimerProgressHighTemp))
        case .lowTemperature:
            setupCook(sender,
                      title: propertiesBrain.getNumber(forIndex: 2).description,
                      selector: #selector(updateTimerProgressLowTemp))
        case .finish:
            performSegue(withIdentifier: K.segues.finishSegue, sender: self)
        }
        
    }
    
    //Set UI and timer for cooking
    func setupCook(_ sender: UIButton, title: String, selector: Selector) {
        timerProgressView.progress = 0
        turnsLeftLabel.isHidden = false
        sender.isHidden = true
        
        timerLabel.text = title
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: selector, userInfo: nil, repeats: true)
    }
    
    //Methods for "passing" updateCooking method as selector
    @objc func updateTimerProgressHighTemp() {
        updateCooking(tempTime: propertiesBrain.getNumber(forIndex: 0), turns: propertiesBrain.getNumber(forIndex: 1), countTime: &highTempTimeInt)
    }
    
    @objc func updateTimerProgressLowTemp() {
        updateCooking(tempTime: propertiesBrain.getNumber(forIndex: 2), turns: propertiesBrain.getNumber(forIndex: 3), countTime: &lowTempTimeInt)
    }
    
    //Update cooking time
    func updateCooking (tempTime: Int, turns: Int, countTime: inout Int) {
        let accuracy = 1.0/Float(tempTime)
        updateTurnsLabel(turns: turns)
        
        if countTime  > 0 {
            timerLabel.text = (countTime - 1).description
            countTime  -= 1
            timerProgressView.progress += accuracy
        }
        else if countTime  == 0 {
            playSound()
            turnsCounter += 1
            
            if turnsCounter == turns * 2 {
                timer.invalidate()
                timerLabel.text = K.Content.Done
                cookButton.isHidden = false
                
                switch cookingStage {
                case .highTemperature:
                    if propertiesBrain.getNumber(forIndex: 2) != 0 &&  propertiesBrain.getNumber(forIndex: 3) != 0 {
                        
                        cookingStage = .lowTemperature
                        turnsCounter = 0
                        updateTurnsLabel(turns: propertiesBrain.getNumber(forIndex: 3))
                        timerLabel.text = propertiesBrain.getNumber(forIndex: 2).description
                    }
                    else {
                        cookButton.setTitle(K.Content.FinishCooking, for: .normal)
                        cookingStage = .finish
                    }
                    
                case .lowTemperature:
                    cookButton.setTitle(K.Content.FinishCooking, for: .normal)
                    cookingStage = .finish
                    
                case .finish:
                    cookButton.setTitle(K.Content.FinishCooking, for: .normal)
                    cookingStage = .finish
                }
                turnsCounter = 0
            } else {
                timerLabel.text = tempTime.description
                timerProgressView.progress = 0
                updateTurnsLabel(turns: turns)
                countTime = tempTime
            }
        }
        //return countTime
    }
    
    //Update turns label
    func updateTurnsLabel(turns: Int) {
        switch cookingStage {
        case .highTemperature:
            turnsLeftLabel.text = "\(K.Content.TurnsLeftAtHighTemp) \(turns * 2 - turnsCounter - 1)"
            
        case .lowTemperature:
            turnsLeftLabel.text = "\(K.Content.TurnsLeftAtLowTemp) \(turns * 2 - turnsCounter - 1)"
            
        case .finish: break
        }
    }
    
    //Play bell sound
    private func playSound() {
        guard let url = Bundle.main.url(forResource: K.Sound.Bell, withExtension: K.Sound.wav) else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print(error)
            return
        }
        player.play()
    }
}
