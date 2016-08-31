//
//  BottomRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 25-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class BottomRectangle: Rectangle {
    override func calculateNewDimensionsFromTouch(touch touch: CGPoint, withOffset offset:CGFloat) {
        if let originPoint = origin {
            let newOriginY:CGFloat = touch.y + fabs(offset)
            let distanceY = self.height + originPoint.y - newOriginY
            self.height = distanceY
            self.origin!.y = newOriginY
        }
    }
}
