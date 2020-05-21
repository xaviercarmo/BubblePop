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
        
        // load the curent player from the players manager
        currentPlayer = PlayersManager.shared.currentPlayer
        // setup the labels to have the current player's values
        initialiseLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // sets up a countdown timer and fires it immediately
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if let currNumber = Int(self.countdownLabel.text ?? "0") {
                // if the last second just elapsed, invalidate the timer and start the game
                if currNumber == 1 {
                    timer.invalidate()
                    self.countdownLabel.isHidden = true
                    self.startGame()
                }
                // otherwise cross-dissolve to the next number in the countdown
                else {
                    UIView.transition(with: self.countdownLabel, duration: 0.1, options: .transitionCrossDissolve, animations: {
                      self.countdownLabel.text = String(currNumber - 1)
                    })
                }
            }
        }).fire()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segueing to the game over view, set the score and old highscore
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
    
    // when a touch occurs in the game view, iterate the bubbles collection
    // and check to see if any should be popped
    private func handleTouchInGameView(_ point: CGPoint) {
        for (bubble, _) in bubbles {
            if bubble.isPointInside(point) {
                bubble.successfulTouch()
                break
            }
        }
    }
    
    // setup the labels to have the current player's values
    private func initialiseLabels() {
        playerNameLabel.text = currentPlayer?.name ?? ""
        
        highscore = currentPlayer?.highscore ?? 0
        playerHighscoreLabel.text = String(highscore)
        
        remainingTime = gameDuration
        currentScoreLabel.text = "0"
        timerLabel.text = String(gameDuration)
        updateTimerLabel()
    }
    
    func startGame() {
        // sets up a timer that clears and spawns bubbles every 1 second, fires immediately
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            // if there is no more time left, stop this timer and end the game
            if self.remainingTime == 0 {
                timer.invalidate()
                self.endGame()
            // otherwise run the game
            } else {
                // if this is the last second of the game, clear all bubbles, otherwise
                // will clear a random amount
                self.clearBubbles(clearAll: self.remainingTime == 1)
                if self.remainingTime != 1 {
                    self.spawnBubbles()
                }
                
                self.remainingTime -= 1
                self.timerLabel.text = String(self.remainingTime)
                self.updateTimerLabel()
            }
        }).fire()
    }
    
    // clears bubbles (option to clear all)
    func clearBubbles(clearAll: Bool = false) {
        for (bubble, _) in bubbles {
            // if bubble is not already disappearing, and it should clear all, or the
            // bubble is off the screen, or they get unlucky, make the bubble disappear
            if !bubble.isRemoving && (clearAll || Int.random(in: 0 ... 1) == 1 || isBubbleOffScreen(bubble)) {
                bubble.disappear(onAnimComplete: removeBubble)
            }
        }
    }
    
    //checks if the bubble is off the top of the gameview
    func isBubbleOffScreen(_ bubble: Bubble) -> Bool {
        if let center = bubble.presentationCenter {
            return center.y < 0
        }
        
        return false
    }
    
    // spawns as many bubbles as it can up to a random limit between 0 and the
    // max number of bubbles to spawn
    func spawnBubbles() {
        // calculates the button size as a proportion of the view width
        let buttonSize = Double(gameAreaView.frame.width / 7)
        // saves half the above size for repeated use
        let halfButtonSize = buttonSize / 2
        // limits the x and y range that buttons can spawn in to the area frame minus a buffer equal
        // to the radius of a button. Prevents buttons from spawning partially off the screen
        let buttonSpawnXRange = halfButtonSize ... Double(gameAreaView.frame.width - CGFloat(halfButtonSize + 1))
        let buttonSpawnYRange = halfButtonSize ... Double(gameAreaView.frame.height - CGFloat(halfButtonSize + 1))
        
        let maxSpawnPointTests = 20
        let numBubblesToSpawn = Int.random(in: 0 ... maxBubbles)
        var newBubbles = [Bubble]()
        for _ in 0 ..< numBubblesToSpawn {
            // tries to generate a center point to spawn the bubble at by generating
            // a random point and checking if spawning a bubble there would cause collision
            var spawnPointTestsCounter = 0
            var randPoint: CGPoint
            repeat {
                spawnPointTestsCounter += 1
                randPoint = CGPoint(x: Double.random(in: buttonSpawnXRange), y: Double.random(in: buttonSpawnYRange))
            } while spawnPointTestsCounter < maxSpawnPointTests
                && !isSpawnPointFree(point: randPoint)
            
            // if there is not enough space to place a bubble within
            // the maximum number of tries, then stop spawning bubbles
            // for this round. This prevents the above while loop from
            // running infinitely if the screen fills up
            if spawnPointTestsCounter >= maxSpawnPointTests {
                break;
            }
            
            // create the new bubble
            let newBubble = Bubble(center: randPoint, size: buttonSize, type: getRandomBubbleType(), onPopped: bubblePopped)
            // set the bubble up to trigger a touch event this view can handle manually
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.buttonTouchGestureHandler))
            newBubble.addGestureRecognizer(gesture)
            
            // add the bubble to collections for tracking and add it to the view
            // so that it is visible
            newBubbles.append(newBubble)
            bubbles.append((bubble: newBubble, gesture: gesture))
            gameAreaView.addSubview(newBubble)
        }
        
        // this is deferred to the end as animating a bubble immediately on spawn
        // can cause issues with the collision detection for spawning
        newBubbles.forEach({ $0.appear() })
    }
    
    // uses the percentages specified by the BubbleType enum
    // to get a random bubble type. Adds up the percentages of
    // all bubble types so that even if they don't sum to 1 it
    // will still distribute their chances in proportion to their
    // enum value
    func getRandomBubbleType() -> BubbleType {
        // sums the total of all the bubble type percentages
        let pctTotal = BubbleType.allCases.reduce(0, { $0 + $1.rawValue })
        
        // picks a random float between 0 and the above total
        let randPct = Float.random(in: 0 ... pctTotal)
        // assigns a chunk of the range (0 to pctTotal) to each bubble type
        // based on its pct value. If random pct falls within the bubble type's
        // chunk, then that is the selected one.
        var prevPct: Float = 0
        for bubbleType in BubbleType.allCases {
            if prevPct ... (prevPct + bubbleType.rawValue) ~= randPct {
                return bubbleType
            }
            
            prevPct += bubbleType.rawValue
        }
        
        //above should not fail to find a bubble type, but if it does then
        // return the most likely bubble type
        return BubbleType.allCases[0]
    }
    
    // checks if any collisions would occur if a bubble were spawned at the
    // given point
    func isSpawnPointFree(point: CGPoint) -> Bool {
        // checks if the point (which represents the centre of the prospective bubble)
        // is within 1.2 * width of any bubble, if it is then the new bubble would be
        // too close so returns false to avoid this
        for (bubble, _) in bubbles {
            if (!bubble.isRemoving) {
                let center = bubble.presentationCenter ?? bubble.center
                let diameter = Double(bubble.maxFrame.width * 1.2)
                if MathUtils.Distance(point, center) <= diameter {
                    return false
                }
            }
        }
        
        return true
    }
    
    // handles the even when a bubble is popped
    func bubblePopped(_ bubble: Bubble) {
        //disable the button to prevent double-taps
        bubble.isEnabled = false
        
        var scoreMultiplier = 1.0
        // increases the score multiplier for consecutive pops
        if lastBubbleType != nil && bubble.bubbleType == lastBubbleType! {
            scoreMultiplier = 1.5
        }
        
        lastBubbleType = bubble.bubbleType
        
        // adds the bubbles score multiplied by the multiplier to the current
        // score and updates the labels accordingly
        let amountToAdd = Int(round(scoreMultiplier * Double(bubble.pointValue)))
        currentScore += amountToAdd
        currentScoreLabel.text = String(currentScore)
        // spawns a floating label where the bubble was popped
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
        label.center = bubble.presentationCenter ?? bubble.center
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
