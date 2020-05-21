//
//  Bubble.swift
//  BubblePop
//
//  Created by Xavier Carmo on 18/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

class Bubble: CircularButton {
    private(set) public var pointValue = 1
    var maxFrame = CGRect(x: 0, y: 0, width: 75, height: 75)
    var isRemoving = false
    
    var presentationCenter: CGPoint? {
        get {
            if let presFrame = layer.presentation()?.frame {
                let halfWidth = CGFloat(presFrame.width / 2.0)
                return CGPoint(x: presFrame.minX + halfWidth, y: presFrame.minY + halfWidth)
            }
            
            return nil
        }
    }
    
    //default bubble is red with width=75
    private var _bubbleType = BubbleType.red
    private var bgImage: UIImage = UIImage(named: "bubble")!
    
    //optional closure to allow consumer to hook into the touch event
    //will be called before bubble is removed from the scene
    private var onPopped: ((_ bubble: Bubble) -> Void)?
    
    //initialiser for programmatic instantiation
    init(center: CGPoint, size: Double, type: BubbleType, onPopped: @escaping (_ bubble: Bubble) -> Void) {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        
        self.center = center
        self.onPopped = onPopped
        bubbleType = type
        
        commonInit()
    }
    
    //initialiser for storyboard instantiation
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        updateImage()
        
        commonInit()
    }
    
    //setup that is common to all initialisers
    private func commonInit() {
        alpha = 0
        maxFrame = frame
        transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        shouldHandleTouches = false
    }
    
    override func successfulTouch() {
        self.isRemoving = true
        UIView.animate(
            withDuration: 0.15,
            animations: {
                self.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                self.alpha = 0
            },
            completion: { Void in()
                self.onPopped?(self)
                self.removeFromSuperview()
            }
        )
    }
    
    var bubbleType: BubbleType {
        get { _bubbleType }
        set {
            _bubbleType = newValue
            updateImage()
        }
    }
    
    func appear() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }
        
        moveUpwards()
    }
    
    func disappear(onAnimComplete: ((_ bubble: Bubble) -> Void)? = nil) {
        self.isRemoving = true
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.beginFromCurrentState],
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.alpha = 0
            },
            completion: { Void in()
                onAnimComplete?(self)
                self.removeFromSuperview()
            }
        )
    }
    
    private func moveUpwards() {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            options: [.curveLinear, .allowUserInteraction, .beginFromCurrentState],
            animations: { self.center.y -= 100 },
            completion: { _ in self.moveUpwards() }
        )
    }
    
    private func updateImage() {
        switch bubbleType {
        case .red:
            pointValue = 1
            setTint(UIColor.red)
        case .pink:
            pointValue = 2
            setTint(UIColor(hue: 310.0/360.0, saturation: 1, brightness: 1, alpha: 1))
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
    
    private func setTint(_ color: UIColor) {
        if let tintedImage = bgImage.tinted(color) {
            bgImage = tintedImage
            setBackgroundImage(bgImage, for: .normal)
        }
    }
}

//CaseIterable enums respect the order of declaration,
//so these are declared in ascending order of probability
//to assist random selection behaviour
enum BubbleType: Float, CaseIterable {
    case black = 0.05
    case blue = 0.1
    case green = 0.15
    case pink = 0.3
    case red = 0.4
}
