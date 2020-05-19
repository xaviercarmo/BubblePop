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
    
    var currentPlayer: Player?
    
    var maxBubbles = 15
    var gameDuration = 60
    
    var remainingTime = 60
    var currentScore = 0
    var highscore = 0
    
    var lastBubbleType: BubbleType?
    var bubbles = [(bubble: Bubble, gesture: UITapGestureRecognizer)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the back button
        self.navigationItem.hidesBackButton = true
        currentPlayer = PlayersManager.shared.currentPlayer
        initialiseLabels()
        
//        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
//        gameAreaView.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if let currNumber = Int(self.countdownLabel.text ?? "0") {
                if currNumber == 1 {
                    timer.invalidate()
                    self.countdownLabel.isHidden = true
                    self.startGame()
                }
                else {
                    UIView.transition(with: self.countdownLabel, duration: 0.1, options: .transitionCrossDissolve, animations: {
                      self.countdownLabel.text = String(currNumber - 1)
                    })
                }
            }
        }).fire()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? GameOverViewController {
            target.score = currentScore
            target.oldHighscore = highscore
        }
    }
    
    // for handling touch events on the game view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            handleTouchInGameView(touch.location(in: gameAreaView))
        }
    }
    
    // for handling touch events on buttons that otherwise would
    // not propagate to the game view
    @objc func buttonTouchGestureHandler(sender: UITapGestureRecognizer) {
        let point = sender.location(in: gameAreaView)
        handleTouchInGameView(point)
    }
    
    func handleTouchInGameView(_ point: CGPoint) {
        for (bubble, _) in bubbles {
            if bubble.isPointInside(point) {
                bubble.successfulTouch()
                break
            }
        }
    }
    
    func initialiseLabels() {
        playerNameLabel.text = currentPlayer?.name ?? ""
        
        highscore = currentPlayer?.highscore ?? 0
        playerHighscoreLabel.text = String(highscore)
        
        remainingTime = gameDuration
        currentScoreLabel.text = "0"
        timerLabel.text = String(gameDuration)
        updateTimerLabel()
    }
    
    func startGame() {
        //remove 5 and .fire() after done testing
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { timer in
            if self.remainingTime == 0 {
                timer.invalidate()
                self.endGame()
            } else {
                
                if self.remainingTime != 1 {
                    self.clearBubbles()
                    self.spawnBubbles()
                } else {
                    self.clearBubbles(clearAll: true)
                }
                
                self.remainingTime -= 1
                self.timerLabel.text = String(self.remainingTime)
                self.updateTimerLabel()
            }
            }).fire()
    }
    
    func clearBubbles(clearAll: Bool = false) {
        for (bubble, _) in bubbles {
            if !bubble.isRemoving && (clearAll || Int.random(in: 0 ... 1) == 0) {
                bubble.disappear(onAnimComplete: removeBubble)
            }
        }
    }
    
    func spawnBubbles() {
        let buttonSize = Double(gameAreaView.frame.width / 7)
        let halfButtonSize = buttonSize / 2 + 1
        let buttonSpawnXRange = halfButtonSize ... Double(gameAreaView.frame.width - CGFloat(halfButtonSize))
        let buttonSpawnYRange = halfButtonSize ... Double(gameAreaView.frame.height - CGFloat(halfButtonSize))
        let maxSpawnPointTests = 20
        
        let numBubblesToSpawn = Int.random(in: 0 ... maxBubbles)
        for _ in 0 ..< numBubblesToSpawn {
            var spawnPointTestsCounter = 0
            var randPoint: CGPoint
            repeat {
                spawnPointTestsCounter += 1
                randPoint = CGPoint(x: Double.random(in: buttonSpawnXRange), y: Double.random(in: buttonSpawnYRange))
            } while spawnPointTestsCounter < maxSpawnPointTests
                && !isSpawnPointFree(point: randPoint)
            
            //if there is not enough space to place a bubble within
            //the maximum number of tries, then stop spawning bubbles
            //for this round. This prevents the above while loop from
            //running infinitely if the screen fills up
            if spawnPointTestsCounter >= maxSpawnPointTests {
                break;
            }
            
            //create the new bubble
            let newBubble = Bubble(center: randPoint, size: buttonSize, type: getRandomBubbleType(), onPopped: bubblePopped)
            
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.buttonTouchGestureHandler))
            newBubble.addGestureRecognizer(gesture)
            
            bubbles.append((bubble: newBubble, gesture: gesture))
            gameAreaView.addSubview(newBubble)
            newBubble.appear()
        }
    }
    
    //uses the percentages specified by the BubbleType enum
    //to get a random bubble type. Adds up the percentages of
    //all bubble types so that even if they don't sum to 1 it
    //will still distribute their chances correctly.
    func getRandomBubbleType() -> BubbleType {
        let pctTotal = BubbleType.allCases.reduce(0, { $0 + $1.rawValue })
        let randPct = Float.random(in: 0 ... pctTotal)
        var prevPct: Float = 0
        for bubbleType in BubbleType.allCases {
            if prevPct ... (prevPct + bubbleType.rawValue) ~= randPct {
                return bubbleType
            }
            
            prevPct += bubbleType.rawValue
        }
        
        //above should not fail to find a bubble type,
        //but if it does then return the most likely
        //bubble type
        return BubbleType.allCases[0]
    }
    
    func isSpawnPointFree(point: CGPoint) -> Bool {
        //checks if the point (which represents the centre of the prospective bubble)
        //is within 2 * radius of any bubble, if it is then the new bubble would overlap
        //so returns false to avoid this
        for (bubble, _) in bubbles {
            if MathUtils.Distance(point, bubble.center) <= Double(bubble.maxFrame.width) {
                return false
            }
        }
        
        return true
    }
    
    func bubblePopped(_ bubble: Bubble) {
        var scoreMultiplier = 1.0
        if lastBubbleType != nil && bubble.bubbleType == lastBubbleType! {
            scoreMultiplier = 1.5
        }
        
        lastBubbleType = bubble.bubbleType
        let amountToAdd = Int(round(scoreMultiplier * Double(bubble.pointValue)))
        currentScore += amountToAdd
        currentScoreLabel.text = String(currentScore)
        spawnPointLabel(bubble: bubble, value: amountToAdd, multiplier: scoreMultiplier)
        
        removeBubble(bubble)
    }
    
    func removeBubble(_ bubble: Bubble) {
        if let index = bubbles.firstIndex(where: { $0.bubble == bubble }) {
            gameAreaView.removeGestureRecognizer(bubbles[index].gesture)
            bubbles.remove(at: index)
        }
    }
    
    func spawnPointLabel(bubble: Bubble, value: Int, multiplier: Double = 1.0) {
        let label = UILabel()
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.text = multiplier == 1.0 ? "+\(String(value))" : "Combo!\n+\(String(value))"
        label.numberOfLines = 2
        let fontSize = bubble.maxFrame.height / 3
        label.font = UIFont(name: "Marker Felt", size: fontSize) ?? label.font.withSize(fontSize)
        label.sizeToFit()
        label.center = bubble.center
        label.layer.zPosition = 1
        gameAreaView.addSubview(label)
        
        //speed = distance / duration
        let animMoveSpeed = (-label.font.lineHeight / 2) //scale the speed to the label size
        let animDuration = 1.0
        let animYOffset = animMoveSpeed * CGFloat(animDuration)
        UIView.animate(
            withDuration: animDuration,
            delay: 0,
            options: .curveLinear,
            animations: {
                label.transform = CGAffineTransform.identity.translatedBy(x: 0, y: animYOffset)
                label.alpha = 0
            },
            completion: { Void in()
                label.removeFromSuperview()
            }
        )
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
        if currentScore > highscore {
            currentPlayer?.highscore = currentScore
        }
        
        performSegue(withIdentifier: "gameOver", sender: nil)
    }
}
