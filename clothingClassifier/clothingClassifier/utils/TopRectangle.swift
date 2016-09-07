//
//  TopRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 25-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class TopRectangle: Rectangle {

    override func calculateNewDimensionsFromPoint(point point: CGPoint, withOffset offset:CGFloat) {
        if origin != nil {
            let newEndY:CGFloat = point.y - fabs(offset)
            self.height = newEndY
            updateRectangle()
        }
    }
}
