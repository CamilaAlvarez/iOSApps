//
//  RightRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 30-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class RightRectangle: Rectangle {
    
    override func calculateNewDimensionsFromTouch(touch touch: CGPoint, withOffset offset: CGFloat) {
        if let originPoint = origin{
            let newOriginX:CGFloat = touch.x + fabs(offset)
            let distanceX:CGFloat = self.width + originPoint.x - newOriginX
            self.width = distanceX
            self.origin!.x = newOriginX
        }
    }
}
