//
//  Rectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 25-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

enum RectangleBorderTouch:Int{
    case noTouch = -1
    case topBorder = 1
    case bottomBorder
    case leftBorder
    case rightBorder
    case topLeftBorder
    case topRightBorder
    case bottomLeftBorder
    case bottomRightBorder
}

struct RectangleOffset{
    var vertical:CGFloat = 0
    var horizontal:CGFloat = 0
}

class Rectangle {
    var width:CGFloat = 0
    var height:CGFloat = 0
    var origin:CGPoint?
    var rectangleView:UIView!
    
    init(rectangleView rect:UIView){
        rectangleView = rect
        let viewFrame = rect.frame
        width = viewFrame.width
        height = viewFrame.height
        origin = viewFrame.origin
    }
    
    func updateRectangle(){
        rectangleView.frame = CGRectMake(origin!.x, origin!.y, width, height)
    }
    
    func getBounds()->CGRect{
        return rectangleView.bounds
    }
    
    func changeWholeRectangle(origin origin:CGPoint?, width:CGFloat, height:CGFloat){
        self.origin = origin
        self.width = width
        self.height = height
    }
    
    func calculateNewDimensionsFromPoint(point point:CGPoint, withOffset offset:CGFloat = 0){
        preconditionFailure("Method must be overriden")
    }

    func containsPoint(point:CGPoint)->Bool{
        if let originPoint = origin{
            return point.x > originPoint.x && point.y > originPoint.y
                && point.x < originPoint.x + width &&  point.y < originPoint.y + height
        }
        return false
    }
    
    func containsPoint(point:CGPoint, withOffset offset:CGFloat)->RectangleBorderTouch{
        if let originPoint = origin{
            let leftCondition = point.x < originPoint.x + offset && point.x > originPoint.x - offset && point.y >= originPoint.y && point.y <= originPoint.y + height
            let rightCondition = point.x < originPoint.x + width + offset && point.x > originPoint.x + width - offset && point.y >= originPoint.y && point.y <= originPoint.y + height
            let topCondition = point.y < originPoint.y + offset && point.y > originPoint.y - offset && point.x >= originPoint.x && point.x <= originPoint.x + width
            let bottomCondition = point.y < originPoint.y + height + offset && point.y > originPoint.y + height - offset && point.x >= originPoint.x && point.x <= originPoint.x + width
            
            if topCondition && leftCondition{
                return RectangleBorderTouch.topLeftBorder
            }
            
            if topCondition && rightCondition{
                return RectangleBorderTouch.topRightBorder
            }
            
            if topCondition{
                return RectangleBorderTouch.topBorder
            }
            
            if bottomCondition && leftCondition{
                return RectangleBorderTouch.bottomLeftBorder
            }
            
            if bottomCondition && rightCondition{
                return RectangleBorderTouch.bottomRightBorder
            }
            
            if bottomCondition {
                return RectangleBorderTouch.bottomBorder
            }
            if rightCondition{
                return RectangleBorderTouch.rightBorder
            }
            if leftCondition{
                return RectangleBorderTouch.leftBorder
            }
        }
        return RectangleBorderTouch.noTouch
    }
}
