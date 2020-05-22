//
//  Bubble.swift
//  BubblePop
//
//  Created by Xavier Carmo on 18/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

// extension of circular button class, inherits the circle-touch-collision
// but does not use the default touch handling as the game handler is 
// responsible for tracking that. Contains all relevant information  and
// functionality for a bubble.
class Bubble: CircularButton {
    // publicly accessible but privately settable point value, re-calculated
    // whenever button type is set
    private(set) public var pointValue = 1
    // the default maximum size of the bubble, overridden in the constructor
    var maxFrame = CGRect(x: 0, y: 0, width: 75, height: 75)
    // boolean indicating if the bubble is currently being removed
    var isRemoving = false
    //integer value indicating the multiplier for movement speed
    var moveSpeed = 1.0
    
    // default bubble type is red, this is a backing member for the
    // bubbleType property
    private var _bubbleType = BubbleType.red
    // the base image to use before tinting based on the button type
    private var bgImage: UIImage = UIImage(named: "bubble")!
    
    // optional closure to allow consumer to hook into the completion
    // of the successfulTouch event
    private var onPopped: ((_ bubble: Bubble) -> Void)?
    
    // initialiser for programmatic instantiation. Takes the center, size,
    // type, and onPopped event
    init(center: CGPoint, size: Double, type: BubbleType, onPopped: @escaping (_ bubble: Bubble) -> Void) {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        
        self.center = center
        self.onPopped = onPopped
        bubbleType = type
        
        // runs init functionality common to all initialisers
        commonInit()
    }
    
    //initialiser for storyboard instantiation
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        // the bubbleType property is not set by this initialiser, so
        // this needs to be called manually
        updateImageAndPoints()
        
        // runs init functionality common to all constructors
        commonInit()
    }
    
    // setup that is common to all initialisers
    private func commonInit() {
        // bubble is invisible with scale = 0 initially
        alpha = 0
        maxFrame = frame
        transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        // prevents the parent class from handling touch functionality
        shouldHandleTouches = false
    }
    
    override func successfulTouch() {
        self.isRemoving = true
        // animates button so that it expands outwards in a "pop"
        UIView.animate(
            withDuration: 0.15,
            animations: {
                self.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                self.alpha = 0
            },
            completion: { Void in()
                // on completion, run the onPopped closure and remove
                // it from the view
                self.onPopped?(self)
                self.removeFromSuperview()
            }
        )
    }

    // property representing the approximate center of the button as it
    // looks to the actual user. Nil whenever an animation is not playing
    // so must be optional
    var presentationCenter: CGPoint? {
        get {
            if let presFrame = layer.presentation()?.frame {
                let halfWidth = CGFloat(presFrame.width / 2.0)
                return CGPoint(x: presFrame.minX + halfWidth, y: presFrame.minY + halfWidth)
            }
            
            return nil
        }
    }
    
    // property handling getting/setting the _bubbleType. Updates the image
    // tint and point value as well
    var bubbleType: BubbleType {
        get { _bubbleType }
        set {
            _bubbleType = newValue
            updateImageAndPoints()
        }
    }
    
    // animates the bubble so that it becomes visible and expands to standard
    // size, as well as rising upwards
    func appear() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }
        
        moveUpwards()
    }
    
    // animates the bubble so that it shrinks and fades away, removing itself
    // upon completion and calling the passed in closure if its defined
    func disappear(onAnimComplete: ((_ bubble: Bubble) -> Void)? = nil) {
        self.isRemoving = true
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: .beginFromCurrentState,
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
    
    // animates the bubble to move up. Recursive so will run forever once
    // triggered. Movement amount is proportional to height of the bubble,
    // so scales to different screen sizes
    private func moveUpwards() {
        if (!isRemoving) {
            let animMoveSpeed = -maxFrame.height * CGFloat(moveSpeed)
            let animDuration: CGFloat = 1.0
            let animYOffset = animMoveSpeed * animDuration
            
            UIView.animate(
                withDuration: 1,
                delay: 0,
                options: [.curveLinear, .allowUserInteraction, .beginFromCurrentState],
                animations: { self.center.y += animYOffset },
                completion: { _ in self.moveUpwards() }
            )
        }
    }
    
    // updates the tint of the bubble and its point value based on the bubble type
    private func updateImageAndPoints() {
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
    
    // sets the tint of the background image using a passed in colour
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
