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
    
    var gameDuration = 60
    var remainingTime = 60
    var currPlayer: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the back button
        self.navigationItem.hidesBackButton = true
        
        startGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //save the score
        
//        if let scoreText = currentScoreLabel.text, let scoreNum = Int(scoreText), let userName = self.navigationItem.title {
//            let userDefaults = UserDefaults.standard
//            userDefaults.set(scoreNum, forKey: "score")
//            userDefaults.set(userName, forKey: "name")
//        }
    }
    
    func startGame() {
        if let player = currPlayer {
            playerNameLabel.text = player.name
            playerHighscoreLabel.text = String(player.highScore)
        }
        
        remainingTime = gameDuration
        currentScoreLabel.text = "0"
        timerLabel.text = String(gameDuration)
        updateTimerLabel()
        
        
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.remainingTime -= 1
            self.timerLabel.text = String(self.remainingTime)
            
            if self.remainingTime == 0 {
                timer.invalidate()
                self.endGame()
            }
            else {
                self.updateTimerLabel()
            }
        })
    }
    
    func updateTimerLabel() {
        let timeFraction = Float(self.remainingTime) / Float(self.gameDuration)
        var newColor: UIColor
        switch(timeFraction) {
        case 0..<0.25:
            newColor = .red
        case 0.25..<0.5:
            newColor = .orange
        case 0.5..<0.75:
            newColor = .blue
        default:
            newColor = .green
        }
        
        UIView.transition(with: self.timerLabel, duration: 0.1, options: .transitionCrossDissolve, animations: {
          self.timerLabel.textColor = newColor
        })
    }
    
    func endGame() {
        self.navigationItem.hidesBackButton = false
    }
}
