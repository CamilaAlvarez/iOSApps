//
//  LeftRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 30-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class LeftRectangle: Rectangle {
    
    override func calculateNewDimensionsFromTouch(touch touch: CGPoint, withOffset offset:CGFloat) {
        if origin != nil {
            let newEndX:CGFloat = touch.x - fabs(offset)
            self.width = newEndX
        }
    }
}
