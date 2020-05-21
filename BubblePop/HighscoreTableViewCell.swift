//
//  HighscoreTableViewCell.swift
//  BubblePop
//
//  Created by Xavier Carmo on 17/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

class HighscoreTableViewCell: UITableViewCell {
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func populateFromPlayer(_ player: Player) {
        playerNameLabel.text = player.name
        scoreLabel.text = String(player.highscore)
    }
}
