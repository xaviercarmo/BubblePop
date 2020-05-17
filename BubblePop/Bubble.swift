//
//  Bubble.swift
//  BubblePop
//
//  Created by Jerry Boyaji on 18/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

class Bubble: CircularButton {
    private(set) public var pointValue = 5
    private var _bubbleType = BubbleType.red
    
    init(frame: CGRect, type: BubbleType) {
        super.init(frame: frame)
        
        bubbleType = type
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var bubbleType: BubbleType {
        get { _bubbleType }
        set {
            _bubbleType = newValue
            
            switch(newValue) {
            case .red:
                pointValue = 1
            case .pink:
                pointValue = 2
            case.green:
                pointValue = 5
            case.blue:
                pointValue = 8
            case.black:
                pointValue = 10
            }
        }
    }
    
    //up to writing spawn method for bubble and then making game controller spawn the bubble
}

enum BubbleType {
    case red
    case pink
    case green
    case blue
    case black
}
