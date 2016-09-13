//
//  CentralRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 30-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

enum DimensionGrowingDirection : CGFloat {
    case OUT = -1
    case INSIDE = 1
}

struct Offset {
    var top:CGFloat = 0
    var bottom:CGFloat = 0
    var right:CGFloat = 0
    var left:CGFloat = 0
}

let borderOffset:CGFloat = 5
class CentralRectangle: Rectangle {
    
    // Offsets work like invisible wall the other rectangles can't cross
    func getOffsetFromPoint(point:CGPoint) -> Offset {
        let offset = Offset()
        if let originPoint = origin {
            var leftOffset = fabs(point.x - originPoint.x)
            var rightOffset = fabs(originPoint.x + width - point.x)
            var topOffset = fabs(point.y - originPoint.y)
            var bottomOffset = fabs(originPoint.y + height - point.y)
            if !self.containsPoint(point){
                switch self.containsPoint(point, withOffset: borderOffset){
                case RectangleBorderTouch.topBorder:
                    topOffset *= -1
                case RectangleBorderTouch.bottomBorder:
                    bottomOffset *= -1
                case RectangleBorderTouch.leftBorder:
                    leftOffset *= -1
                case RectangleBorderTouch.rightBorder:
                    rightOffset *= -1
                case RectangleBorderTouch.bottomLeftBorder:
                    bottomOffset *= -1
                    leftOffset *= -1
                case RectangleBorderTouch.topLeftBorder:
                    topOffset *= -1
                    leftOffset *= -1
                case RectangleBorderTouch.bottomRightBorder:
                    bottomOffset *= -1
                    rightOffset *= -1
                case RectangleBorderTouch.topRightBorder:
                    topOffset *= -1
                    rightOffset *= -1
                default:
                    break
                }
            }
            return Offset(top: topOffset, bottom: bottomOffset, right: rightOffset, left: leftOffset)
        }
        return offset
    }
    
    override func calculateNewDimensionsFromPoint(point point: CGPoint, withOffset offset: CGFloat = 0) {
        if !self.containsPoint(point){
            switch containsPoint(point, withOffset: borderOffset) {
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
            switch containsPoint(startingPoint, withOffset: borderOffset){
            case RectangleBorderTouch.noTouch:
                origin!.x = originPoint.x + (finishPoint.x - startingPoint.x)
                origin!.y = originPoint.y + (finishPoint.y - startingPoint.y)
            case RectangleBorderTouch.topLeftBorder:
                originPoint.x = finishPoint.x
                originPoint.y = finishPoint.y
                changeDimension({() in return DimensionGrowingDirection.INSIDE.rawValue},
                                          originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            case RectangleBorderTouch.topRightBorder:
                originPoint.y = finishPoint.y
                changeVerticalDimension({() in return DimensionGrowingDirection.INSIDE.rawValue},
                                        originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
                changeHorizontalDimension({() in return DimensionGrowingDirection.OUT.rawValue},
                                          originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            case RectangleBorderTouch.leftBorder:
                originPoint.x = finishPoint.x
                changeHorizontalDimension({() in return DimensionGrowingDirection.INSIDE.rawValue},
                                originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            case RectangleBorderTouch.bottomLeftBorder:
                originPoint.x = finishPoint.x
                changeHorizontalDimension({() in return DimensionGrowingDirection.INSIDE.rawValue},
                                        originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
                changeVerticalDimension({() in return DimensionGrowingDirection.OUT.rawValue},
                                originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            case RectangleBorderTouch.topBorder:
                originPoint.y = finishPoint.y
                changeVerticalDimension({() in return DimensionGrowingDirection.INSIDE.rawValue},
                                originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            case RectangleBorderTouch.bottomRightBorder:
                changeDimension({() in return DimensionGrowingDirection.OUT.rawValue},
                                originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            case RectangleBorderTouch.rightBorder:
                changeHorizontalDimension({() in return DimensionGrowingDirection.OUT.rawValue},
                                originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            case RectangleBorderTouch.bottomBorder:
                changeVerticalDimension({() in return DimensionGrowingDirection.OUT.rawValue},
                                originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
            }
        }
        else{
            let originY = min(startingPoint.y, finishPoint.y)
            let originX = min(startingPoint.x , finishPoint.x)
            origin = CGPointMake(originX, originY)
            
            //To keep the rectangle from being invisible
            height = max(fabs(finishPoint.y - startingPoint.y),1)
            width = max(fabs(finishPoint.x - startingPoint.x),1)
        }
        updateRectangle()
    }
    
    private func changeHorizontalDimension(growthFuntion:()->CGFloat, originPoint:CGPoint, startingPoint:CGPoint, finishPoint:CGPoint){
        var newOrigin = originPoint
        var newWidth = width + growthFuntion()*(startingPoint.x - finishPoint.x)
        
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
    
    private func changeVerticalDimension(growthFuntion:()->CGFloat, originPoint:CGPoint, startingPoint:CGPoint, finishPoint:CGPoint){
        var newOrigin = originPoint
        var newHeight = height + growthFuntion()*(startingPoint.y - finishPoint.y)
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
    
    private func changeDimension(growthFuntion:()->CGFloat, originPoint:CGPoint, startingPoint:CGPoint, finishPoint:CGPoint){
        changeVerticalDimension(growthFuntion, originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
        changeHorizontalDimension(growthFuntion, originPoint: originPoint, startingPoint: startingPoint, finishPoint: finishPoint)
    }
}
