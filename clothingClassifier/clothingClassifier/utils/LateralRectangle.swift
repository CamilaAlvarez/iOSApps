//
//  LateralRectangle.swift
//  mercadolibre-ios
//
//  Created by Camila Alvarez on 06-09-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class LateralRectangle: Rectangle {
    
    func calculateNewDimensionsFromPoint(point point:CGPoint, withOffset offset:CGFloat, newHeight:CGFloat, newOriginY:CGFloat){
        if origin != nil{
            calculateNewDimensionsFromPoint(point: point, withOffset: offset)
            height = newHeight
            origin!.y = newOriginY
            updateRectangle()
        }
    }
    
    override func calculateNewDimensionsFromPoint(point point: CGPoint, withOffset offset: CGFloat) {
        if let originPoint = origin{
            modifyHorizontalMeasure(point: point, withOffset: offset)
            if point.y > originPoint.y{
                height = point.y - originPoint.y
            }
            else{
                height += fabs(originPoint.y - point.y)
            }
            origin!.y = min(originPoint.y, point.y)
        }
    }
    
    func modifyHorizontalMeasure(point point: CGPoint, withOffset offset: CGFloat){
        preconditionFailure("Method need to be overriden")
    }
}