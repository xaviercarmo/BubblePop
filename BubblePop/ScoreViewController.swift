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

    var players = [Player]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        highscoreTableView.dataSource = self
        highscoreTableView.delegate = self
        
        // Populate players if it exists
        let defaults = UserDefaults.standard
        if let playerListData = defaults.data(forKey: "PlayerList"),
            let playerList = try? JSONDecoder().decode([Player].self, from: playerListData) {
            players = playerList
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! HighscoreTableViewCell
        cell.populateFromPlayer(players[indexPath.row])
        
        return cell
    }
}
