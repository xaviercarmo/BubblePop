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
    
    var remainingTime = 60
    var currPlayer: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the back button
        self.navigationItem.hidesBackButton = true
        
        // Use player to setup labels
        if let player = currPlayer {
            playerNameLabel.text = player.name
            playerHighscoreLabel.text = String(player.highScore)
        }
        
        currentScoreLabel.text = "0"
        timerLabel.text = String(remainingTime)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.remainingTime -= 1
            if self.remainingTime > 0 {
                self.timerLabel.text = String(self.remainingTime)
            }
            else {
                self.endGame()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //save the score
        
//        if let scoreText = currentScoreLabel.text, let scoreNum = Int(scoreText), let userName = self.navigationItem.title {
//            let userDefaults = UserDefaults.standard
//            userDefaults.set(scoreNum, forKey: "score")
//            userDefaults.set(userName, forKey: "name")
//        }
    }
    
    func endGame() {
        
    }
}
