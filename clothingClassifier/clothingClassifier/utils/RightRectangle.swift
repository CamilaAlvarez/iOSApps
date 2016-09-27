//
//  RightRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 30-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class RightRectangle: LateralRectangle {
    
    override func modifyHorizontalMeasure(point: CGPoint, withOffset offset: CGFloat) {
        if let originPoint = origin{
            let newOriginX:CGFloat = point.x + offset
            let distanceX:CGFloat = self.width + originPoint.x - newOriginX
            self.width = distanceX
            origin!.x = newOriginX
        }
    }
    
}
