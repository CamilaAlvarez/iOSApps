//
//  BottomRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 25-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class BottomRectangle: Rectangle {
    override func calculateNewDimensionsFromTouch(touch touch: CGPoint) {
        if let originPoint = origin {
            let distanceY = originPoint.y + self.height - touch.y
            self.height = distanceY
            self.origin!.y = touch.y
        }
    }
}
