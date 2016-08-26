//
//  Rectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 25-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class Rectangle {
    var width:CGFloat = 0
    var height:CGFloat = 0
    var origin:CGPoint?
    var rectangleView:UIView!
    
    init(rectangleView rect:UIView){
        rectangleView = rect
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
    
    func calculateNewDimensionsFromTouch(touch touch:CGPoint){
        preconditionFailure("Method must be overriden")
    }

    
}
