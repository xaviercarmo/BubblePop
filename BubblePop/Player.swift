//
//  File.swift
//  BubblePop
//
//  Created by Jerry Boyaji on 17/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import Foundation

class Player: Codable {
    var name = ""
    var highScore = 0
    
    init(name: String) {
        self.name = name
    }
}
