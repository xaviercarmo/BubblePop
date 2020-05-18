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
    var maxFrame = CGRect(x: 0, y: 0, width: 75, height: 75)
    
    //default bubble is red with width=75
    private var _bubbleType = BubbleType.red
    private var bgImage: UIImage = UIImage(named: "bubble")!
    
    //initiliaser for programmatic instantiation
    init(frame: CGRect, type: BubbleType) {
        super.init(frame: frame)
        
//        maxSize = self.frame
        bubbleType = type
        
        commonInit()
//        self.alpha = 0
//        self.frame = CGRect(origin: maxSize.origin, size: CGSize.zero)
    }
    
    //initialiser for storyboard instantiation
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
//        maxSize = self.frame
        updateImage()
        
        commonInit()
//        self.alpha = 0
//        self.frame = CGRect(origin: maxSize.origin, size: CGSize.zero)
    }
    
    //setup that is common to all initialisers
    private func commonInit() {
        alpha = 0
        maxFrame = frame
        transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
//        frame = CGRect(origin: maxFrame.origin, size: CGSize.zero)
    }
    
    override func successfulTouch() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            animations: {
                self.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                self.alpha = 0
            },
            completion: { Void in()
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
        
//        UIView.animate(
//            withDuration: 2.0,
//            delay: 0,
//            usingSpringWithDamping: CGFloat(0.20),
//            initialSpringVelocity: CGFloat(6.0),
//            options: UIView.AnimationOptions.allowUserInteraction,
//            animations: { self.transform = CGAffineTransform.identity },
//            completion: { Void in() }
//        )
    }
    
    private func updateImage() {
        switch(bubbleType) {
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
    
    private func setTint(_ color: UIColor) {
        if let tintedImage = bgImage.tinted(color) {
            bgImage = tintedImage
//            self.clipsToBounds = true
//            self.contentMode = .center
//            self.layer.cornerRadius = self.bounds.width / 2
//            print(self.bounds.width, self.maxFrame)
//            self.setImage(tintedImage, for: .normal)
            setBackgroundImage(bgImage, for: .normal)
        }
    }
}

enum BubbleType : CaseIterable {
    case red, pink, green, blue, black
}
