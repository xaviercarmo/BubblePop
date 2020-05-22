//
//  ScoreViewController.swift
//  BubblePop
//
//  Created by Xavier Carmo on 16/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var highscoreTableView: UITableView!
    
    // gets the players as a list from the dictionary in the players manager
    var players = Array(PlayersManager.shared.players.values)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sort the players list by highscore descending
        players.sort(by: { $0.highscore > $1.highscore })
        
        // setup the highscore table to use this class
        highscoreTableView.dataSource = self
        highscoreTableView.delegate = self
    }
    
    // table only has one section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // one row for each player
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    // populates the cells with data from the players list
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! HighscoreTableViewCell
        cell.populateFromPlayer(players[indexPath.row])
        
        return cell
    }
}
