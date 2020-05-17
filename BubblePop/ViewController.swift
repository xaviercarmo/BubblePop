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
        // Do any additional setup after loading the view.
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
            var playerList = defaults.object(forKey: "PlayerList") as? [String] ?? [String]()
            if let playerName = nameTextField.text, playerName != "" {
                if !playerList.contains(playerName) {
                    playerList.append(playerName)
                }
            }
            else {
                nameTextField.layer.borderColor = UIColor(named: "red")?.cgColor
                return
            }
        }
    }
    
    @IBAction func nameTextFieldChanged(_ sender: Any) {
        validateNameTextField()
    }
    
    func validateNameTextField() -> Bool {
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
