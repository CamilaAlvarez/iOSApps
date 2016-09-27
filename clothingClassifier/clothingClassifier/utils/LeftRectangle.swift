//
//  LeftRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 30-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class LeftRectangle: LateralRectangle {
    
    override func modifyHorizontalMeasure(point: CGPoint, withOffset offset: CGFloat) {
        let newEndX:CGFloat = point.x - offset
        self.width = newEndX
    }
    
}
