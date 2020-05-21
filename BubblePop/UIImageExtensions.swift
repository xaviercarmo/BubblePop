//
//  UIImageExtensions.swift
//  BubblePop
//
//  Created by Xavier Carmo on 18/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func tinted(_ tintColor: UIColor) -> UIImage? {
        // setup graphics context, this is an extension of UIImage so size and scale
        // refer to the size/scale of the current image
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // context uses the quartz coord system (0,0 at bottom left)
        // which is different to coordinate system used by UIKit (0,0 at top left).
        // need to flip the context vertically so that when UIButton renders the image
        //"upside down" it's actually the right way up
        context.translateBy(x: 0, y: size.height);
        context.scaleBy(x: 1.0, y: -1.0);
        
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        
        // draw original image
        context.setBlendMode(.normal)
        context.draw(self.cgImage!, in: rect)

        // fill the button background with colour and make it blend
        // with the original image colour
        context.setBlendMode(.color)
        tintColor.setFill()
        context.fill(rect)

        // apply the alpha values from the original image
        context.setBlendMode(.destinationIn)
        context.draw(self.cgImage!, in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
