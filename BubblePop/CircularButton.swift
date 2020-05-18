//
//  CircularButton.swift
//  BubblePop
//
//  Created by Jerry Boyaji on 18/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import UIKit

class CircularButton: UIButton {
    final override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var point = CGPoint()
        if let touch = touches.first {
            point = touch.location(in: self.superview)
        }

        let radius = (self.frame.width / 2.0)
        if(MathUtils.Distance(point, self.center) < Float(radius)) {
            successfulTouch()
            super.touchesBegan(touches, with: event)
        }
    }
    
    func successfulTouch() {}
}
