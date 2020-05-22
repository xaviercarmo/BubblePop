//
//  CircularButton.swift
//  BubblePop
//
//  Created by Xavier Carmo on 18/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

// extension of the button class that enables circular-touch collision
// so that buttons with circular background images are not clickable
// at their corners
class CircularButton: UIButton {
    var shouldHandleTouches = true
    
    // when a touch occurs, check if it was inside the circle, and if it was call
    // the successfulTouch handler and propagate to the parent class
    final override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if shouldHandleTouches, let touch = touches.first,
            isPointInside(touch.location(in: self.superview)) {
            successfulTouch()
            super.touchesBegan(touches, with: event)
        }
    }
    
    // prefentially checks if the passed in point is inside the presentation frame, or
    // the default frame if the former is nil.
    func isPointInside(_ point: CGPoint) -> Bool {
        let currFrame = layer.presentation()?.frame ?? frame
        let radius = CGFloat(currFrame.width / 2.0)
        let center = CGPoint(x: currFrame.minX + radius, y: currFrame.minY + radius)
        //if a point is within the radius of the button, then it is inside
        return MathUtils.Distance(point, center) <= Double(radius)
    }
    
    // overrideable so that child classes can hook into the touchesBegan event
    func successfulTouch() {}
}
