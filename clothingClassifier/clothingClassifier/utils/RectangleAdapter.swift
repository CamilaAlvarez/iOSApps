//
//  RectangleAdapter.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 30-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class RectangleAdapter: NSObject {
    private var topRectangle:TopRectangle!
    private var bottomRectangle:BottomRectangle!
    private var leftRectangle:LeftRectangle!
    private var rightRectangle:RightRectangle!
    private var mainRectangle:CentralRectangle!
    
    init(forView parentView:UIView!) {
        super.init()
        let initialFrame : CGRect = CGRectMake(0, 0, 0, 0)
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
        mainView.backgroundColor = UIColor.clearColor()
        mainView.layer.borderWidth = 2
        mainView.layer.borderColor = UIColor.whiteColor().CGColor
        mainRectangle = CentralRectangle(rectangleView: mainView)
        let topView = createGenericView(frame: CGRectMake(0, 0, parentViewSize.width, rect.origin.y)
            , withParent: parentView)
        let bottomOriginY = rect.origin.y+rect.height
        let bottomView = createGenericView(frame: CGRectMake(0, bottomOriginY, parentViewSize.width,
            parentViewSize.height-bottomOriginY), withParent: parentView)
        let leftView = createGenericView(frame: CGRectMake(0, rect.origin.y, rect.origin.x, rect.height)
            , withParent: parentView)
        let rightOriginX = rect.origin.x+rect.width
        let rightView = createGenericView(frame: CGRectMake(rightOriginX, rect.origin.y ,
            parentViewSize.width - rightOriginX, rect.height), withParent: parentView)
        
        topRectangle = TopRectangle(rectangleView: topView)
        bottomRectangle = BottomRectangle(rectangleView: bottomView)
        leftRectangle = LeftRectangle(rectangleView: leftView)
        rightRectangle = RightRectangle(rectangleView: rightView)
    }

    private func createGenericView(frame frame: CGRect, withParent parent:UIView)->UIView{
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        parent.addSubview(view)
        return view
    }
    
    private func updateSecondaryRectangles(point:CGPoint){
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
