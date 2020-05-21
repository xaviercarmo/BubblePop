//
//  File.swift
//  BubblePop
//
//  Created by Xavier Carmo on 17/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import Foundation

class Player: Codable {
    private enum CodingKeys: String, CodingKey {
        case name, highscore
    }
    
    var onChanged: ((_ player: Player) -> Void)?
    
    var name = "" {
        didSet {
            onChanged?(self)
        }
    }
    
    var highscore = 0 {
        didSet {
            onChanged?(self)
        }
    }
    
    init(name: String = "") {
        self.name = name
    }
    
    func copyFrom(_ player: Player) {
        name = player.name
        highscore = player.highscore
    }
}
