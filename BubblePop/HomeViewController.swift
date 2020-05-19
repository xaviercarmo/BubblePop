//
//  ViewController.swift
//  BubblePop
//
//  Created by Xavier Carmo on 16/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    //IB Control outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var settingsViewSubView: UIView!
    @IBOutlet weak var maxBubblesLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var maxBubblesSlider: UISlider!
    @IBOutlet weak var durationSlider: UISlider!
    
    //private constants and variables
    private let defaults = UserDefaults.standard
    private let playersManager = PlayersManager.shared
    private var defaultMaxBubbles = 15
    private var defaultGameDuration = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = playersManager.currentPlayer?.name ?? ""
        
        initialiseSettingsView()
    }
    
    func initialiseSettingsView() {
        let maxBubbles = defaults.object(forKey: "maximumBubbles") as? Int ?? defaultMaxBubbles
        maxBubblesLabel.text = "Maximum Bubbles: \(maxBubbles)"
        maxBubblesSlider.value = Float(maxBubbles)
        
        let gameDuration = defaults.object(forKey: "gameDuration") as? Int ?? defaultGameDuration
        durationLabel.text = "Game Duration: \(gameDuration)"
        durationSlider.value = Float(gameDuration)
        
        settingsView.alpha = 0
        
        settingsViewSubView.layer.cornerRadius = 5
        settingsViewSubView.layer.masksToBounds = true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return identifier == "PlayGameSegue"
            ? validateNameTextField()
            : true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? GameViewController, let playerName = nameTextField.text {
            playersManager.ChangePlayer(name: playerName, createIfMissing: true)

            target.maxBubbles = Int(maxBubblesSlider.value)
            target.gameDuration = Int(durationSlider.value)
        }
    }

    @IBAction func settingsButtonPressed(_ sender: Any) {
        //fade the settings subview in
        UIView.animate(withDuration: 0.25) {
            self.settingsView.alpha = 1.0
        }
    }
    
    @IBAction func subViewOkButtonPressed(_ sender: Any) {
        //save the new settings
        defaults.set(Int(maxBubblesSlider.value), forKey: "maximumBubbles")
        defaults.set(Int(durationSlider.value), forKey: "gameDuration")
        
        //fade the settings subview out
        UIView.animate(withDuration: 0.1) {
            self.settingsView.alpha = 0.0
        }
    }
    
    @IBAction func maxBubblesSliderValueChanged(_ sender: UISlider) {
        maxBubblesLabel.text = "Maximum Bubbles: \(Int(sender.value))"
    }
    
    @IBAction func gameDurationSliderValueChanged(_ sender: UISlider) {
        durationLabel.text = "Game Duration: \(Int(sender.value))"
    }
    
    @IBAction func nameTextFieldChanged(_ sender: Any) {
        validateNameTextField()
    }
    
    @discardableResult func validateNameTextField() -> Bool {
        if let name = nameTextField.text, name != "" {
            nameTextField.layer.borderWidth = 0.0
            
            return true
        }
        else {
            nameTextField.layer.borderColor = UIColor.red.cgColor
            nameTextField.layer.borderWidth = 1.0
            nameTextField.layer.cornerRadius = 4.0
            nameTextField.layer.masksToBounds = true
            
            return false
        }
    }
}
