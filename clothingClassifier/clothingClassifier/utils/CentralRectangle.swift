//
//  CentralRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 30-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

enum DimensionGrowingDirection : CGFloat {
    case out = -1
    case inside = 1
}

struct Offset {
    var top:CGFloat = 0
    var bottom:CGFloat = 0
    var right:CGFloat = 0
    var left:CGFloat = 0
}

class CentralRectangle: Rectangle {
    // Offsets work like invisible wall the other rectangles can't cross
    func getOffsetFromPoint(_ point:CGPoint) -> Offset {
        let offset = Offset()
        if let originPoint = origin {
            var leftOffset = fabs(point.x - originPoint.x)
            var rightOffset = fabs(originPoint.x + width - point.x)
            var topOffset = fabs(point.y - originPoint.y)
            var bottomOffset = fabs(originPoint.y + height - point.y)
            if !self.containsPoint(point){
                check(offset: &leftOffset, withCondition: point.x < originPoint.x)
                check(offset: &rightOffset, withCondition: point.x > (originPoint.x + width))
                check(offset: &bottomOffset, withCondition: point.y > (originPoint.y + height))
                check(offset: &topOffset, withCondition: point.y < originPoint.y)
            }
            return Offset(top: topOffset, bottom: bottomOffset, right: rightOffset, left: leftOffset)
        }
        return offset
    }
    
    fileprivate func check(offset:inout CGFloat, withCondition condition:Bool){
        if offset < rectangleConstants.borderOffset.rawValue && condition{
            offset *= DimensionGrowingDirection.out.rawValue
        }
    }
    
    override func calculateNewDimensionsFromPoint(point: CGPoint, withOffset offset: CGFloat = 0) {
        if !self.containsPoint(point){
            switch containsPoint(point, withOffset: rectangleConstants.borderOffset.rawValue) {
            case RectangleBorderTouch.noTouch:
                if let originPoint = origin {
                    if point.x > originPoint.x{
                        width = point.x - originPoint.x
                    }
                    else{
                        width += fabs(originPoint.x - point.x)
                    }
                    
                    if point.y > originPoint.y{
                        height = point.y - originPoint.y
                    }
                    else{
                        height += fabs(originPoint.y - point.y)
                    }
                    
                    origin!.x = min(originPoint.x, point.x)
                    origin!.y = min(originPoint.y, point.y)
                    updateRectangle()
                }

            default:
                break
            }
            
        }
    }
    
    func translateRectangle(from startingPoint:CGPoint, to finishPoint:CGPoint){
        if var originPoint = origin{
            if self.containsPoint(startingPoint){
                origin!.x = originPoint.x + (finishPoint.x - startingPoint.x)
                origin!.y = originPoint.y + (finishPoint.y - startingPoint.y)
                updateRectangle()
                return
            }

            switch containsPoint(startingPoint, withOffset: rectangleConstants.borderOffset.rawValue){
            case RectangleBorderTouch.noTouch:
                    origin!.x = originPoint.x + (finishPoint.x - startingPoint.x)
                    origin!.y = originPoint.y + (finishPoint.y - startingPoint.y)
            case RectangleBorderTouch.topLeftBorder:
                originPoint.x = finishPoint.x
                originPoint.y = finishPoint.y
                changeDimension({() in return DimensionGrowingDirection.inside.rawValue},
                                          originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            case RectangleBorderTouch.topRightBorder:
                originPoint.y = finishPoint.y
                changeVerticalDimension({() in return DimensionGrowingDirection.inside.rawValue},
                                        originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
                changeHorizontalDimension({() in return DimensionGrowingDirection.out.rawValue},
                                          originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            case RectangleBorderTouch.leftBorder:
                originPoint.x = finishPoint.x
                changeHorizontalDimension({() in return DimensionGrowingDirection.inside.rawValue},
                                originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            case RectangleBorderTouch.bottomLeftBorder:
                originPoint.x = finishPoint.x
                changeHorizontalDimension({() in return DimensionGrowingDirection.inside.rawValue},
                                        originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
                changeVerticalDimension({() in return DimensionGrowingDirection.out.rawValue},
                                originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            case RectangleBorderTouch.topBorder:
                originPoint.y = finishPoint.y
                changeVerticalDimension({() in return DimensionGrowingDirection.inside.rawValue},
                                originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            case RectangleBorderTouch.bottomRightBorder:
                changeDimension({() in return DimensionGrowingDirection.out.rawValue},
                                originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            case RectangleBorderTouch.rightBorder:
                changeHorizontalDimension({() in return DimensionGrowingDirection.out.rawValue},
                                originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            case RectangleBorderTouch.bottomBorder:
                changeVerticalDimension({() in return DimensionGrowingDirection.out.rawValue},
                                originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            }
        }
        else{
            let originY = min(startingPoint.y, finishPoint.y)
            let originX = min(startingPoint.x , finishPoint.x)
            origin = CGPoint(x: originX, y: originY)
            
            //To keep the rectangle from being invisible
            height = max(fabs(finishPoint.y - startingPoint.y),1)
            width = max(fabs(finishPoint.x - startingPoint.x),1)
        }
        updateRectangle()
    }
    
    fileprivate func changeHorizontalDimension(_ growthFuntion:()->CGFloat, originPoint:CGPoint, startingPoint:CGPoint, finishPoint:CGPoint){
        var newOrigin = originPoint
        var newWidth = width + growthFuntion()*(startingPoint.x - finishPoint.x)
        if newWidth < rectangleConstants.minimunDimesion.rawValue{
            return
        }
        
        if newWidth < 0 {
            newWidth = fabs(newWidth)
            if finishPoint.x < startingPoint.x {
                newOrigin.x -= newWidth
            }
            else{
                newOrigin.x += newWidth
            }
        }
        
        origin!.x = newOrigin.x
        width = newWidth
    }
    
    fileprivate func changeVerticalDimension(_ growthFuntion:()->CGFloat, originPoint:CGPoint, startingPoint:CGPoint, finishPoint:CGPoint){
        var newOrigin = originPoint
        var newHeight = height + growthFuntion()*(startingPoint.y - finishPoint.y)
        
        if newHeight < rectangleConstants.minimunDimesion.rawValue {
            return
        }
        
        if newHeight < 0 {
            newHeight = fabs(newHeight)
            if finishPoint.y < startingPoint.y {
                newOrigin.y -= newHeight
            }
            else{
                newOrigin.y += height
            }
        }
        
        origin!.y = newOrigin.y
        height = newHeight
    }
    
    fileprivate func changeDimension(_ growthFuntion:()->CGFloat, originPoint:CGPoint, startingPoint:CGPoint, finishPoint:CGPoint){
        changeVerticalDimension(growthFuntion, originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
        changeHorizontalDimension(growthFuntion, originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
    }
}
