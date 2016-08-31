//
//  RectangleAdapter.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 30-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class RectangleAdapter: NSObject {
    private var topRectangle:Rectangle!
    private var bottomRectangle:Rectangle!
    private var leftRectangle:Rectangle!
    private var rightRectangle:Rectangle!
    
    init(forView parentView:UIView!) {
        super.init()
        let initialFrame : CGRect = CGRectMake(0, 0, 0, 0)
        let topView = createGenericView(frame: initialFrame, withParent: parentView)
        let bottomView = createGenericView(frame: initialFrame, withParent: parentView)
        let leftView = createGenericView(frame: initialFrame, withParent: parentView)
        let rightView = createGenericView(frame: initialFrame, withParent: parentView)
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
    
    func updateRectangles(forTouch touch:UITouch){
    
    }
}
