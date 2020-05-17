//
//  MathUtils.swift
//  BubblePop
//
//  Created by Jerry Boyaji on 18/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import Foundation
import UIKit

//Purely static enum. Cannot be initialised, only for use as a static
//collection of utility methods.
enum MathUtils {
    static func Distance(_ from: CGPoint, _ to: CGPoint) -> Float {
        return self.Distance((x: Float(from.x), y: Float(from.y)), (x: Float(to.x), y: Float(to.y)))
    }
    
    static func Distance(_ from: (x: Float, y: Float), _ to: (x: Float, y: Float)) -> Float {
        let diffX = to.x - from.x
        let diffY = to.y - from.y
        return sqrt(powf(diffX, 2) + powf(diffY, 2))
    }
}
