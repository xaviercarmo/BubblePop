//
//  MathUtils.swift
//  BubblePop
//
//  Created by Xavier Carmo on 18/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import Foundation
import UIKit

//Purely static enum. Cannot be initialised, only for use as a static
//collection of utility methods.
enum MathUtils {
    // calculates the distance between two x and y coordinates
    static func Distance(_ from: (x: Double, y: Double), _ to: (x: Double, y: Double)) -> Double {
        let diffX = to.x - from.x
        let diffY = to.y - from.y
        return sqrt(pow(diffX, 2) + pow(diffY, 2))
    }

    // overload for above distance method that takes CGPoints as parameters
    static func Distance(_ from: CGPoint, _ to: CGPoint) -> Double {
        return self.Distance((x: Double(from.x), y: Double(from.y)), (x: Double(to.x), y: Double(to.y)))
    }
}
