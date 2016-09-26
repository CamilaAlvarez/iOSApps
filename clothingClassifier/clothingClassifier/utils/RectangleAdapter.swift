//
//  RectangleAdapter.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 30-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

enum rectangleConstants : CGFloat{
    case borderOffset = 5
    case lineWidth = 2
    case minimunDimesion = 10
}

class RectangleAdapter: NSObject {
    fileprivate var topRectangle:TopRectangle!
    fileprivate var bottomRectangle:BottomRectangle!
    fileprivate var leftRectangle:LeftRectangle!
    fileprivate var rightRectangle:RightRectangle!
    fileprivate var mainRectangle:CentralRectangle!
    
    init(forView parentView:UIView!) {
        super.init()
        let initialFrame : CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let topView = createGenericView(frame: initialFrame, withParent: parentView)
        let bottomView = createGenericView(frame: initialFrame, withParent: parentView)
        let leftView = createGenericView(frame: initialFrame, withParent: parentView)
        let rightView = createGenericView(frame: initialFrame, withParent: parentView)
        let mainView = createGenericView(frame: initialFrame, withParent: parentView)
        topRectangle = TopRectangle(rectangleView: topView)
        bottomRectangle = BottomRectangle(rectangleView: bottomView)
        leftRectangle = LeftRectangle(rectangleView: leftView)
        rightRectangle = RightRectangle(rectangleView: rightView)
        mainRectangle = CentralRectangle(rectangleView: mainView)
    }
    
    init(forView parentView:UIView!, withCropperRect rect:CGRect){
        super.init()
        let parentViewSize = parentView.frame.size
        let mainView = createGenericView(frame: rect, withParent: parentView)
        mainView.backgroundColor = UIColor.clear
        mainView.layer.borderWidth = rectangleConstants.lineWidth.rawValue
        mainView.layer.borderColor = UIColor.white.cgColor
        mainRectangle = CentralRectangle(rectangleView: mainView)
        let topView = createGenericView(frame: CGRect(x: 0, y: 0, width: parentViewSize.width, height: rect.origin.y)
            , withParent: parentView)
        let bottomOriginY = rect.origin.y+rect.height
        let bottomView = createGenericView(frame: CGRect(x: 0, y: bottomOriginY, width: parentViewSize.width,
            height: parentViewSize.height-bottomOriginY), withParent: parentView)
        let leftView = createGenericView(frame: CGRect(x: 0, y: rect.origin.y, width: rect.origin.x, height: rect.height)
            , withParent: parentView)
        let rightOriginX = rect.origin.x+rect.width
        let rightView = createGenericView(frame: CGRect(x: rightOriginX, y: rect.origin.y ,
            width: parentViewSize.width - rightOriginX, height: rect.height), withParent: parentView)
        
        topRectangle = TopRectangle(rectangleView: topView)
        bottomRectangle = BottomRectangle(rectangleView: bottomView)
        leftRectangle = LeftRectangle(rectangleView: leftView)
        rightRectangle = RightRectangle(rectangleView: rightView)
    }

    fileprivate func createGenericView(frame: CGRect, withParent parent:UIView)->UIView{
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        parent.addSubview(view)
        return view
    }
    
    fileprivate func updateSecondaryRectangles(_ point:CGPoint){
        let offset = mainRectangle.getOffsetFromPoint(point)
        topRectangle.calculateNewDimensionsFromPoint(point: point, withOffset: offset.top)
        bottomRectangle.calculateNewDimensionsFromPoint(point: point, withOffset: offset.bottom)
        leftRectangle.calculateNewDimensionsFromPoint(point: point, withOffset: offset.left, newHeight: mainRectangle.height, newOriginY: mainRectangle.origin!.y)
        rightRectangle.calculateNewDimensionsFromPoint(point: point, withOffset: offset.right, newHeight: mainRectangle.height, newOriginY: mainRectangle.origin!.y)
    }
    
    func updateRectangles(forPoint point:CGPoint){
        mainRectangle.calculateNewDimensionsFromPoint(point: point)
        updateSecondaryRectangles(point)
    }
    
    func moveCentralRectangle(fromPoint startingPoint:CGPoint, to finishPoint:CGPoint){
        mainRectangle.translateRectangle(from: startingPoint, to: finishPoint)
        updateSecondaryRectangles(finishPoint)
    }
}
