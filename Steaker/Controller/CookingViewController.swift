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
    
    var player: AVAudioPlayer!
    
    var highTempTime: Int?
    var highTempTurns: Int?
    var lowTempTime: Int?
    var lowTempTurns: Int?

    var propertiesBrain = PropertyBrain()
    
    var timer = Timer()
    
    var highTempTimeInt: Int = 0
    var lowTempTimeInt: Int = 0

    var turnsCounter = 0
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cookButton.contentHorizontalAlignment = .center
        cookButton.titleLabel?.textAlignment = .center
        
        timerLabel.adjustsFontForContentSizeCategory = true
        turnsLeftLabel.adjustsFontForContentSizeCategory = true
        
        updateTurnsLabel(turns: highTempTurns!)
        
        timerLabel.text = String(highTempTime!)
        timerProgressView.progress = 0
        
        highTempTimeInt = Int(highTempTime!)
        lowTempTimeInt = Int(lowTempTime!)
    }
    
    func updateTurnsLabel (turns: Int) {
        if cookButton.titleLabel?.text == (K.cookHighTemp) {
            turnsLeftLabel.text = "\(K.turnsLeftAtHighTemp) \(turns * 2 - turnsCounter - 1)"
        } else if cookButton.titleLabel?.text == (K.cookLowTemp){
            turnsLeftLabel.text = "\(K.turnsLeftAtLowTemp) \(turns * 2 - turnsCounter - 1)"
        }
    }
     
    func updateCooking (tempTime: Int, turns: Int, countTime: inout Int) -> Int {
        let accuracy = 1.0/Float(tempTime)
        updateTurnsLabel(turns: turns)
        print(accuracy)
        print(tempTime)
        
        if countTime  > 0 {
            timerLabel.text = String(countTime - 1)
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
                
                if cookButton.titleLabel?.text == (K.cookHighTemp) && lowTempTime != 0 && lowTempTurns != 0 {
                    cookButton.setTitle(K.cookLowTemp, for: .normal)
                    cookButton.titleLabel?.text = K.cookLowTemp
                    turnsCounter = 0
                    updateTurnsLabel(turns: lowTempTurns!)
                } else if cookButton.titleLabel?.text == (K.cookLowTemp) {
                    cookButton.setTitle(K.finishCooking, for: .normal)
                } else {
                    cookButton.setTitle(K.finishCooking, for: .normal)
                }
                
                turnsCounter = 0
            } else {
                timerLabel.text = String(tempTime)
                timerProgressView.progress = 0
                updateTurnsLabel(turns: turns)
                countTime = tempTime
            }
        }
        return countTime
    }
    
    @objc func updateTimerProgressHighTemp() {
        updateCooking(tempTime: highTempTime!, turns: highTempTurns!, countTime: &highTempTimeInt)
    }
    
    @objc func updateTimerProgressLowTemp() {
        updateCooking(tempTime: lowTempTime!, turns: lowTempTurns!, countTime: &lowTempTimeInt)
    }

    @IBAction func cookButtonPressed(_ sender: UIButton) {

        if sender.titleLabel?.text == K.cookHighTemp {
            
            timerProgressView.progress = 0
            turnsLeftLabel.isHidden = false
            sender.isHidden = true
            //turnsLeftLabel.text = "Turns left at high temp: \(Int(highTempTurns!)! * 2 - turnsCounter - 1)"
            
            timerLabel.text = String(highTempTime!)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerProgressHighTemp), userInfo: nil, repeats: true)
            
        } else if sender.titleLabel?.text == K.cookLowTemp {
            
            timerProgressView.progress = 0
            turnsLeftLabel.isHidden = false
            sender.isHidden = true
            //updateTurnsLabel(turns: Int(lowTempTurns!)!)
            //turnsLeftLabel.text = "Turns left at low temp: \(Int(lowTempTurns!)! * 2 - turnsCounter - 1)"
            
            timerLabel.text = String(lowTempTime!)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerProgressLowTemp), userInfo: nil, repeats: true)
        } else {
            //Text field for history alert placeholders 
            var nameTextField = UITextField()
            var noteTextField = UITextField()
            
            //New alert with title
            let alert = UIAlertController(title: "Do you want to add this meat to the history?", message: nil, preferredStyle: .alert)
            
            //New alert for adding to the history
            let historyAlert = UIAlertController(title: "Add meat to the history", message: "", preferredStyle: .alert)
            
            //Press Yes button on the alert window
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                self.present(historyAlert, animated: true)
            }))
            
            //Press no button on the alert window
            alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (UIAlertAction) in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            
            //Press cancel on the alert window
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            }))
            
            
            
            //Press add button on the history alerty window
            historyAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
                
                let newHistoryItem = History()
                //let contentArray = [self.lowTempTurns,self.lowTempTime,self.highTempTurns,self.highTempTime]
                let contentArray = [self.highTempTime,self.highTempTurns,self.lowTempTime,self.lowTempTurns]
                
                if nameTextField.text?.isEmpty == false /*!= ""*/ {
                    newHistoryItem.name = nameTextField.text!
                    newHistoryItem.dateCreated = Date()
                    do {
                        try self.realm.write(){
                            self.realm.add(newHistoryItem)
                            
                            for index in 0...3 {
                                let newPropertyItem = HistoryItem()
                                newPropertyItem.title = self.propertiesBrain.properties[index].title + " \(contentArray[index]!)"
                                newPropertyItem.dateCreated = Date()
                                newHistoryItem.items.append(newPropertyItem)
                            }
                            
                            if noteTextField.text?.isEmpty == false /*!= ""*/ {
                                let newPropertyItem = HistoryItem()
                                newPropertyItem.title = " " + noteTextField.text! + " "
                                newPropertyItem.dateCreated = Date()
                                newHistoryItem.items.append(newPropertyItem)
                            }
                            
                            
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    } catch {
                        print("Error saving history item to Realm, \(error)")
                    }
                }
            }))
            
            //Press no button on the history alert window
            historyAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (UIAlertAction) in
            }))
            
            //Textfields for this history Alert
            historyAlert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Name"
                alertTextField.autocapitalizationType = .sentences
                nameTextField = alertTextField
            }
            historyAlert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Notes"
                alertTextField.autocapitalizationType = .sentences
                noteTextField = alertTextField
            }
            
            //Present alert
            present(alert, animated: true)
        }
    }
    
    func playSound() {
           let url = Bundle.main.url(forResource: "bell", withExtension: "wav")
           player = try! AVAudioPlayer(contentsOf: url!)
           player.play()
                   
       }
}
