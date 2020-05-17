//
//  ViewController.swift
//  BubblePop
//
//  Created by Xavier Carmo on 16/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
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
    private var defaultMaxBubbles = 15
    private var defaultGameDuration = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the name text field to the current player's name if it exists
        if let currPlayerData = defaults.data(forKey: "CurrentPlayer"),
            let currPlayer = try? JSONDecoder().decode(Player.self, from: currPlayerData) {
            nameTextField.text = currPlayer.name
        }
        
        initialiseSettingsView()
    }
    
    func initialiseSettingsView() {
        let maxBubbles = defaults.object(forKey: "MaximumBubbles") as? Int ?? defaultMaxBubbles
        maxBubblesLabel.text = "Maximum Bubbles: \(maxBubbles)"
        maxBubblesSlider.value = Float(maxBubbles)
        
        let gameDuration = defaults.object(forKey: "GameDuration") as? Int ?? defaultGameDuration
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
        if let target = segue.destination as? GameViewController {
            //save the name to the list in userdefaults
            let defaults = UserDefaults.standard
            if let playerName = nameTextField.text {
                let playerListData = defaults.data(forKey: "PlayerList")
                
                var playerList = playerListData != nil
                    ? (try? JSONDecoder().decode([Player].self, from: playerListData!)) ?? [Player]()
                    : [Player]()
                
                var currPlayer: Player?
                for player in playerList {
                    if (player.name == playerName) {
                        currPlayer = player
                        break
                    }
                }
                
                if currPlayer == nil {
                    currPlayer = Player(name: playerName)
                    playerList.append(currPlayer!)
                }
                
                //set defaults current player and playerlist
                if let encodedPlayerList = try? JSONEncoder().encode(playerList) {
                    defaults.set(encodedPlayerList, forKey: "PlayerList")
                }
                
                if let encodedCurrPlayer = try? JSONEncoder().encode(currPlayer) {
                    defaults.set(encodedCurrPlayer, forKey: "CurrentPlayer")
                }
                
                //pass the current player on to the game view controller
                target.currPlayer = currPlayer
            }
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
        defaults.set(Int(maxBubblesSlider.value), forKey: "MaximumBubbles")
        defaults.set(Int(durationSlider.value), forKey: "GameDuration")
        
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
