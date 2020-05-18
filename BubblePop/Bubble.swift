//
//  Bubble.swift
//  BubblePop
//
//  Created by Jerry Boyaji on 18/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

class Bubble: CircularButton {
    private(set) public var pointValue = 1
    
    private var _bubbleType = BubbleType.red
    private var bgImage: UIImage = UIImage(named: "bubble")!
    
    init(frame: CGRect, type: BubbleType) {
        super.init(frame: frame)
        
        bubbleType = type
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        bubbleType = _bubbleType
    }
    
    var bubbleType: BubbleType {
        get { _bubbleType }
        set {
            _bubbleType = newValue
            
            switch(newValue) {
            case .red:
                pointValue = 1
                setTint(UIColor.systemRed)
            case .pink:
                pointValue = 2
                setTint(UIColor.systemPink)
            case.green:
                pointValue = 5
                setTint(UIColor.systemGreen)
            case.blue:
                pointValue = 8
                setTint(UIColor.blue)
            case.black:
                pointValue = 10
                setTint(UIColor.black)
            }
        }
    }
    
    private func setTint(_ color: UIColor) {
        if let tintedImage = bgImage.tinted(color) {
            bgImage = tintedImage
            self.setBackgroundImage(bgImage, for: .normal)
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
