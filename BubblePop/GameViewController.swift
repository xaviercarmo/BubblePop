//
//  GameViewController.swift
//  BubblePop
//
//  Created by Xavier Carmo on 16/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var currentScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //save the score
        
        if let scoreText = self.currentScore.text, let scoreNum = Int(scoreText), let userName = self.navigationItem.title {
            let userDefaults = UserDefaults.standard
            userDefaults.set(scoreNum, forKey: "score")
            userDefaults.set(userName, forKey: "name")
        }
    }
    
    @IBAction func addOneScore(_ sender: Any) {
        if let scoreText = self.currentScore.text, var scoreNum = Int(scoreText) {
            scoreNum += 1
            self.currentScore.text = String(scoreNum)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
