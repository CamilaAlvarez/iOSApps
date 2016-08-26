//
//  TopRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 25-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class TopRectangle: Rectangle {

    override func calculateNewDimensionsFromTouch(touch touch: CGPoint) {
        if let originPoint = origin {
            let distanceY = touch.y - originPoint.y
            self.height = distanceY
        }
    }
}
