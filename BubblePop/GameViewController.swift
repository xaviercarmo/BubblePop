//
//  GameViewController.swift
//  BubblePop
//
//  Created by Xavier Carmo on 16/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playerHighscoreLabel: UILabel!
    
    var currPlayer: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the back button
        self.navigationItem.hidesBackButton = true
        
        // Use player to setup labels
        if let player = currPlayer {
            print("yay")
            playerNameLabel.text = player.name
            playerHighscoreLabel.text = String(player.highScore)
        }
        
        currentScoreLabel.text = "0"
        timerLabel.text = "60"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //save the score
        
//        if let scoreText = currentScoreLabel.text, let scoreNum = Int(scoreText), let userName = self.navigationItem.title {
//            let userDefaults = UserDefaults.standard
//            userDefaults.set(scoreNum, forKey: "score")
//            userDefaults.set(userName, forKey: "name")
//        }
    }
}
