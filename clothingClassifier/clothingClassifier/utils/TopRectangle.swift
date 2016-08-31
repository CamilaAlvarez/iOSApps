//
//  TopRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 25-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class TopRectangle: Rectangle {

    override func calculateNewDimensionsFromTouch(touch touch: CGPoint, withOffset offset:CGFloat) {
        if origin != nil {
            let newEndY:CGFloat = touch.y - fabs(offset)
            self.height = newEndY
        }
    }
}
