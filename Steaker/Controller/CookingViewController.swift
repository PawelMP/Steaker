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
    
    //FIXME: - 
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
        
        updateTurnsLabel(turns: propertiesBrain.properties[1].number)
        
        timerLabel.text = propertiesBrain.properties[0].number.description 
        timerProgressView.progress = 0
        
        highTempTimeInt = propertiesBrain.properties[0].number
        lowTempTimeInt = propertiesBrain.properties[2].number
    }
    
    func setupController() {
        cookButton.titleLabel?.textAlignment = .center
    }
    
    func updateTurnsLabel(turns: Int) {
        if cookButton.titleLabel?.text == K.cookHighTemp {
            turnsLeftLabel.text = "\(K.turnsLeftAtHighTemp) \(turns * 2 - turnsCounter - 1)"
        } else if cookButton.titleLabel?.text == K.cookLowTemp {
            turnsLeftLabel.text = "\(K.turnsLeftAtLowTemp) \(turns * 2 - turnsCounter - 1)"
        }
    }
    
    @discardableResult
    func updateCooking (tempTime: Int, turns: Int, countTime: inout Int) -> Int {
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
                timerLabel.text = K.doneText
                cookButton.isHidden = false
                
                switch cookingStage {
                case .highTemperature:
                    if propertiesBrain.properties[2].number != 0 && propertiesBrain.properties[3].number != 0 {
                    cookButton.titleLabel?.text = K.cookLowTemp
                    cookButton.setTitle(K.cookLowTemp, for: .normal)
                    turnsCounter = 0
                    updateTurnsLabel(turns: propertiesBrain.properties[3].number)
                    cookingStage = .lowTemperature
                    }
                case .lowTemperature:
                    cookButton.setTitle(K.finishCooking, for: .normal)
                    cookingStage = .finish
                case .finish:
                    cookButton.setTitle(K.finishCooking, for: .normal)
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
        return countTime
    }
    
    @objc
    func updateTimerProgressHighTemp() {
        updateCooking(tempTime: propertiesBrain.properties[0].number, turns: propertiesBrain.properties[1].number, countTime: &highTempTimeInt)
    }
    
    @objc
    func updateTimerProgressLowTemp() {
        updateCooking(tempTime: propertiesBrain.properties[2].number, turns: propertiesBrain.properties[3].number, countTime: &lowTempTimeInt)
    }
    
    func setupCook(_ sender: UIButton, title: String, selector: Selector) {
        timerProgressView.progress = 0
        turnsLeftLabel.isHidden = false
        sender.isHidden = true
        
        timerLabel.text = title
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: selector, userInfo: nil, repeats: true)
    }
    
    @IBAction func cookButtonPressed(_ sender: UIButton) {
        
        switch cookingStage {
        case .highTemperature:
            setupCook(sender,
                      title: propertiesBrain.properties[0].number.description,
                      selector: #selector(updateTimerProgressHighTemp))
        case .lowTemperature:
            setupCook(sender,
                      title: propertiesBrain.properties[2].number.description,
                      selector: #selector(updateTimerProgressLowTemp))
        case .finish:
            //New alert with title
            let alert = UIAlertController(title: K.questionAddMeatToHistory, message: nil, preferredStyle: .alert)
            
            //New alert for adding to the history
            let historyAlert = UIAlertController(title: K.addMeatToHistory, message: nil, preferredStyle: .alert)
            let historyAlertTextField = AlertTextField(alert: historyAlert)
            let nameTextField = historyAlertTextField.initializeTextField(text: K.name)
            let noteTextField = historyAlertTextField.initializeTextField(text: K.notes)
            
            //Press Yes button on the alert window
            alert.addAction(UIAlertAction(title: K.yes, style: .default, handler: { (UIAlertAction) in
                self.present(historyAlert, animated: true)
            }))
            
            //Press no button on the alert window
            alert.addAction(UIAlertAction(title: K.no, style: .destructive, handler: { (UIAlertAction) in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            
            //Press cancel on the alert window
            alert.addAction(UIAlertAction(title: K.cancel, style: .cancel, handler: { (UIAlertAction) in
            }))
            
            //Press add button on the history alerty window
            historyAlert.addAction(UIAlertAction(title: K.add, style: .default, handler: { (UIAlertAction) in
                
                if nameTextField.text?.isEmpty == false {
                    let history = RealmManager.shared.saveHistory(text: nameTextField.text!)
                    
                    for index in (0...3).reversed() {
                        RealmManager.shared.saveHistoryItem(currentSteak: history, text: self.propertiesBrain.properties[index].title + self.propertiesBrain.properties[index].number.description)
                    }
                    
                    if noteTextField.text?.isEmpty == false {
                        RealmManager.shared.saveHistoryItem(currentSteak: history, text: noteTextField.text!)
                    }
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }))
            
            //Press no button on the history alert window
            historyAlert.addAction(UIAlertAction(title: K.cancel, style: .destructive, handler: { (UIAlertAction) in
            }))
            present(alert, animated: true)
        }
        
    }
    
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "bell", withExtension: "wav") else {
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
