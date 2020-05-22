//
//  GameOverViewController.swift
//  BubblePop
//
//  Created by Xavier Carmo on 19/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var oldHighscoreLabel: UILabel!
    @IBOutlet weak var oldHighscoreTitleLabel: UILabel!
    @IBOutlet weak var newHighscoreLabel: UILabel!
    @IBOutlet weak var newHighscoreTitleLabel: UILabel!
    
    var playersManager = PlayersManager.shared
    var score: Int = 0
    var oldHighscore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // hides the back button so that the user cannot navigate back to the game
        navigationItem.hidesBackButton = true
        
        // updates all the labels based on the user's score, and whether they broke
        // their highscore or not
        scoreLabel.text = " \(score)"
        
        oldHighscoreLabel.text = " \(oldHighscore)"
        if score > oldHighscore {
            oldHighscoreTitleLabel.text = "Your old highscore:"
            newHighscoreLabel.text = " \(score)"
        }
        else {
            newHighscoreTitleLabel.isHidden = true
            newHighscoreLabel.isHidden = true
        }
    }
    
    // returns to the home screen when the user is finished looking at their new score
    @IBAction func homeButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
