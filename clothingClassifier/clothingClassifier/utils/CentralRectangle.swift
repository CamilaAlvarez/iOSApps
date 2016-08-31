//
//  CentralRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 30-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class CentralRectangle: Rectangle {
    
    func getOffsetFromTouch(touch:CGPoint) -> [String : CGFloat] {
        let offsetDictionary:[String:CGFloat] = ["top": 0, "bottom": 0, "right":0, "left":0]
        if let originPoint = origin {
            guard rectangleView.pointInside(touch, withEvent: nil) else {
                return offsetDictionary
            }
            let leftOffset = fabs(touch.x - originPoint.x)
            let rightOffset = fabs(originPoint.x + width - touch.x)
            let topOffset = fabs(touch.y - originPoint.y)
            let bottomOffset = fabs(originPoint.y + height - touch.y)
            return ["top": topOffset, "bottom": bottomOffset, "right":rightOffset, "left":leftOffset]
        }
        return offsetDictionary
    }
    
    override func calculateNewDimensionsFromTouch(touch touch: CGPoint, withOffset offset: CGFloat = 0) {
        if !rectangleView.pointInside(touch, withEvent: nil){
            if let originPoint = origin {
                if touch.x > originPoint.x{
                    width = touch.x - originPoint.x
                }
                else{
                    width += fabs(originPoint.x - touch.x)
                    origin!.x = touch.x
                    
                }
                
                if touch.y > originPoint.y{
                    height = touch.y
                }
                else{
                    height += fabs(originPoint.y - touch.y)
                    origin!.y = touch.y
                }
            }
        }
    }
}
