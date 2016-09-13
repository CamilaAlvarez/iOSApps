//
//  BottomRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 25-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class BottomRectangle: Rectangle {
    override func calculateNewDimensionsFromPoint(point point: CGPoint, withOffset offset:CGFloat) {
        if let originPoint = origin {
            let newOriginY:CGFloat = point.y + offset
            let distanceY = self.height + (originPoint.y - newOriginY)
            self.height = distanceY
            self.origin!.y = newOriginY
            updateRectangle()
        }
    }
}
