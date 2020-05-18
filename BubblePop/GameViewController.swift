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
    @IBOutlet weak var gameAreaView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var maxBubbles = 15
    var gameDuration = 60
    var remainingTime = 60
    var currPlayer: Player?
    
    var bubbles = [Bubble]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the back button
        self.navigationItem.hidesBackButton = true
        
        initialiseLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            timer.invalidate()
            self.countdownLabel.isHidden = true
            self.startGame()
            
            if let currNumber = Int(self.countdownLabel.text ?? "0") {
                if currNumber == 1 {
                    timer.invalidate()
                    self.countdownLabel.isHidden = true
                    self.startGame()
                }
                else {
                    UIView.transition(with: self.countdownLabel, duration: 0.15, options: .transitionCrossDissolve, animations: {
                      self.countdownLabel.text = String(currNumber - 1)
                    })
                }
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
    
    func initialiseLabels() {
        if let player = currPlayer {
            playerNameLabel.text = player.name
            playerHighscoreLabel.text = String(player.highScore)
        }
        
        remainingTime = gameDuration
        currentScoreLabel.text = "0"
        timerLabel.text = String(gameDuration)
        updateTimerLabel()
    }
    
    func startGame() {
        self.spawnBubbles()
        self.navigationItem.hidesBackButton = false
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
//            self.remainingTime -= 1
//            self.timerLabel.text = String(self.remainingTime)
//            self.updateTimerLabel()
//
//            if self.remainingTime == 0 {
//                timer.invalidate()
//                self.endGame()
//            }
//            else {
//                self.spawnBubbles()
//            }
//        })
    }
    
    func clearBubbles() {
        
    }
    
    func spawnBubbles() {
//        let gameCenter = gameAreaView.center
        
//        let frame = CGRect(x: gameCenter.x, y: gameCenter.y, width: buttonSize, height: buttonSize)
//        let newBubble = Bubble(frame: frame, type: BubbleType.red)
//        gameAreaView.addSubview(newBubble)
//        newBubble.appear()
        
        let buttonSize = Int(gameAreaView.frame.width / 7)
        let halfButtonSize = Int(buttonSize / 2) + 1
        
//        let numBubblesToSpawn = Int.random(in: 0 ... maxBubbles)
//        for _ in 0 ..< numBubblesToSpawn {
        for _ in 0 ..< 10 {
            var randX, randY: Int
            repeat {
                randX = Int.random(in: halfButtonSize ... (Int(gameAreaView.frame.width) - halfButtonSize))
                randY = Int.random(in: halfButtonSize ... (Int(gameAreaView.frame.height) - halfButtonSize))
            } while !isSpawnPointFree(point: (x: Float(randX), y: Float(randY)))
            
            let newBubbleFrame = CGRect(x: randX - halfButtonSize, y: randY - halfButtonSize, width: buttonSize, height: buttonSize)
            let randBubbleType = BubbleType.allCases.randomElement()!
            let newBubble = Bubble(frame: newBubbleFrame, type: randBubbleType)
            gameAreaView.addSubview(newBubble)
            newBubble.appear()
            bubbles.append(newBubble)
        }
    }
    
    func isSpawnPointFree(point: (x: Float, y: Float)) -> Bool {
        //checks if the point (which represents the centre of the prospective bubble)
        //is within 2 * radius of any bubble, if it is then the new bubble would overlap
        //so returns false to avoid this
        for bubble in bubbles {
            if MathUtils.Distance(point, (x: Float(bubble.center.x), y: Float(bubble.center.y))) <= Float(bubble.maxFrame.width) {
                print("sfh;lsuhbulhgufdhg")
                return false
            }
        }
        
        return true
    }
    
    func updateTimerLabel() {
        let timeFraction = Float(self.remainingTime) / Float(self.gameDuration)
        var newColor: UIColor
        switch(timeFraction) {
        case 0..<0.33:
            newColor = .red
        case 0.25..<0.66:
            newColor = .orange
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
