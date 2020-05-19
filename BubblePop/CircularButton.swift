//
//  CircularButton.swift
//  BubblePop
//
//  Created by Jerry Boyaji on 18/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

class CircularButton: UIButton {
    var shouldHandleTouches = true
    
    final override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if shouldHandleTouches, let touch = touches.first,
            isPointInside(touch.location(in: self.superview)) {
            successfulTouch()
            super.touchesBegan(touches, with: event)
        }
    }
    
    func isPointInside(_ point: CGPoint) -> Bool {
        if let presentationFrame = layer.presentation()?.frame {
//            let point = touch.location(in: self.superview)
            let radius = CGFloat(presentationFrame.width / 2.0)
            let center = CGPoint(x: presentationFrame.minX + radius, y: presentationFrame.minY + radius)
            if MathUtils.Distance(point, center) <= Double(radius) {
                return true
            }
        }
        
        return false
    }
    
    func successfulTouch() {}
}
