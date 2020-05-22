//
//  File.swift
//  BubblePop
//
//  Created by Xavier Carmo on 17/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import Foundation

// serialiazable class representing a player. Saves their
// name and highscore
class Player: Codable {
    private enum CodingKeys: String, CodingKey {
        case name, highscore
    }
    
    // event that consumers can set which is triggered when a
    // property is changed
    var onChanged: ((_ player: Player) -> Void)?
    
    // name member that triggers onChanged when set
    var name = "" {
        didSet {
            onChanged?(self)
        }
    }
    
    // highscore member that triggers onChanged when set
    var highscore = 0 {
        didSet {
            onChanged?(self)
        }
    }
    
    init(name: String = "") {
        self.name = name
    }
}
