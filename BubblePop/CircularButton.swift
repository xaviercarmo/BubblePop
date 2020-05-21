//
//  CircularButton.swift
//  BubblePop
//
//  Created by Xavier Carmo on 18/5/20.
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
        let currFrame = layer.presentation()?.frame ?? frame
        let radius = CGFloat(currFrame.width / 2.0)
        let center = CGPoint(x: currFrame.minX + radius, y: currFrame.minY + radius)
        return MathUtils.Distance(point, center) <= Double(radius)
        
//        if let presentationFrame = layer.presentation()?.frame {
//            let radius = CGFloat(presentationFrame.width / 2.0)
//            let center = CGPoint(x: presentationFrame.minX + radius, y: presentationFrame.minY + radius)
//            if MathUtils.Distance(point, center) <= Double(radius) {
//                return true
//            }
//        }
//
//        return false
    }
    
    func successfulTouch() {}
}
