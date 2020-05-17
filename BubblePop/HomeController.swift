//
//  ViewController.swift
//  BubblePop
//
//  Created by Xavier Carmo on 16/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the name text field to the current player's name if it exists
        let defaults = UserDefaults.standard
        if let currPlayerData = defaults.data(forKey: "CurrentPlayer"),
            let currPlayer = try? JSONDecoder().decode(Player.self, from: currPlayerData) {
            nameTextField.text = currPlayer.name
        }
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
                
                print(playerList)
                
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
