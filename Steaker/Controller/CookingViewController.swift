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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cookButton.contentHorizontalAlignment = .center
        cookButton.titleLabel?.textAlignment = .center
        
        updateTurnsLabel(turns: propertiesBrain.properties[1].number)
        
        timerLabel.text = propertiesBrain.properties[0].number.description 
        timerProgressView.progress = 0
        
        highTempTimeInt = propertiesBrain.properties[0].number
        lowTempTimeInt = propertiesBrain.properties[2].number
    }
    
    func updateTurnsLabel(turns: Int) {
        if cookButton.titleLabel?.text == K.cookHighTemp {
            turnsLeftLabel.text = "\(K.turnsLeftAtHighTemp) \(turns * 2 - turnsCounter - 1)"
        } else if cookButton.titleLabel?.text == K.cookLowTemp {
            turnsLeftLabel.text = "\(K.turnsLeftAtLowTemp) \(turns * 2 - turnsCounter - 1)"
        }
    }
     
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
                
                if cookButton.titleLabel?.text == K.cookHighTemp && propertiesBrain.properties[2].number != 0 && propertiesBrain.properties[3].number != 0 {
                    cookButton.setTitle(K.cookLowTemp, for: .normal)
                    cookButton.titleLabel?.text = K.cookLowTemp
                    turnsCounter = 0
                    updateTurnsLabel(turns: propertiesBrain.properties[3].number)
                } else if cookButton.titleLabel?.text == (K.cookLowTemp) {
                    cookButton.setTitle(K.finishCooking, for: .normal)
                } else {
                    cookButton.setTitle(K.finishCooking, for: .normal)
                }
                
                turnsCounter = 0
            } else {
                timerLabel.text = (tempTime).description
                timerProgressView.progress = 0
                updateTurnsLabel(turns: turns)
                countTime = tempTime
            }
        }
        return countTime
    }
    
    @objc func updateTimerProgressHighTemp() {
        updateCooking(tempTime: propertiesBrain.properties[0].number, turns: propertiesBrain.properties[1].number, countTime: &highTempTimeInt)
    }
    
    @objc func updateTimerProgressLowTemp() {
        updateCooking(tempTime: propertiesBrain.properties[2].number, turns: propertiesBrain.properties[3].number, countTime: &lowTempTimeInt)
    }

    @IBAction func cookButtonPressed(_ sender: UIButton) {

        if sender.titleLabel?.text == K.cookHighTemp {
            
            timerProgressView.progress = 0
            turnsLeftLabel.isHidden = false
            sender.isHidden = true

            timerLabel.text = propertiesBrain.properties[0].number.description
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerProgressHighTemp), userInfo: nil, repeats: true)
            
        } else if sender.titleLabel?.text == K.cookLowTemp {
            
            timerProgressView.progress = 0
            turnsLeftLabel.isHidden = false
            sender.isHidden = true

            timerLabel.text = propertiesBrain.properties[2].number.description
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
                
                if nameTextField.text?.isEmpty == false {
                    newHistoryItem.name = nameTextField.text!
                    newHistoryItem.dateCreated = Date()
                    do {
                        try self.realm.write(){
                            self.realm.add(newHistoryItem)
                            
                            for index in (0...3).reversed() {
                                let newPropertyItem = HistoryItem()
                                newPropertyItem.title = self.propertiesBrain.properties[index].title + self.propertiesBrain.properties[index].number.description
                                newPropertyItem.dateCreated = Date()
                                newHistoryItem.items.append(newPropertyItem)
                            }
                            
                            if noteTextField.text?.isEmpty == false {
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
