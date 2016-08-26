//
//  AdaptableRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 17-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

private var myContext = 0

class AdaptableRectangle: UIImageView {
    
    class Rectangle: NSObject {
        var width:CGFloat = 0
        dynamic var height:CGFloat = 0
        var origin:CGPoint?
        var rectangleView:UIView!
        
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
        
        override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
            if context == &myContext {
                if let newValue = change?[NSKeyValueChangeNewKey], rect = object as? Rectangle {
                    if let _ = self.origin{//Separar esto
                        self.origin!.y = rect.origin!.y
                    }
                    self.height = newValue as! CGFloat
                    
                }
            } else {
                super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            }
        }
    }
    
    private var topView: Rectangle = Rectangle()
    private var leftView: Rectangle = Rectangle()
    private var bottomView: Rectangle = Rectangle()
    private var rightView: Rectangle = Rectangle()
    private var rectangleView: Rectangle = Rectangle()
    private var isSliding = false
    private let initialHeightWidth : CGFloat = 100
    private let borderWidth : CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
        self.addExternalSubviews()
    }
    
    
    private func setUp() {
        let initialFrame : CGRect = CGRectMake(0, 0, 0, 0)
        topView.rectangleView = self.createGenericView(frame: initialFrame)
        bottomView.rectangleView = self.createGenericView(frame: initialFrame)
        leftView.rectangleView = self.createGenericView(frame: initialFrame)
        rightView.rectangleView = self.createGenericView(frame: initialFrame)
        rectangleView.rectangleView = self.createGenericView(frame: initialFrame)
        rectangleView.rectangleView.layer.borderWidth = 2
        rectangleView.rectangleView.layer.borderColor = UIColor.whiteColor().CGColor
        rectangleView.rectangleView.backgroundColor = UIColor.clearColor()
        rectangleView.addObserver(leftView, forKeyPath: "height", options: .New, context: &myContext)
        rectangleView.addObserver(rightView, forKeyPath: "height", options: .New, context: &myContext)
        
    }
    
    private func createGenericView(frame frame: CGRect)->UIView{
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }
    
    private func addSubview(rectangle: Rectangle) {
        self.addSubview(rectangle.rectangleView);
    }
    
    private func addExternalSubviews(){
        self.addSubview(topView)
        self.addSubview(leftView)
        self.addSubview(rightView)
        self.addSubview(bottomView)
        self.addSubview(rectangleView)
    }
    
    init(withImageView imageView: UIImageView){
        super.init(frame: imageView.frame)
        self.setUp()
        self.contentMode = imageView.contentMode
        self.addExternalSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
        self.addExternalSubviews()
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch touches.count{
        case 1:
            if let touch = touches.first{
                let position : CGPoint = touch.locationInView(self)
                if CGRectContainsPoint(self.rectangleView.getBounds(), position){
                    self.isSliding = true
                }
                else{
                    let positionY:CGFloat = position.y
                    let positionX:CGFloat = position.x
                    if let origin = rectangleView.origin{
                        let distanceX:CGFloat = positionX - origin.x
                        let distanceY:CGFloat = positionY - origin.y
                    
                        if distanceX > 0{
                            rectangleView.width = distanceX
                            rightView.origin?.x = positionX
                            rightView.width = self.frame.width - positionX
                        }
                        else{
                            rectangleView.width -= distanceX
                            rectangleView.origin?.x = positionX
                            leftView.width = positionX
                        }
                    
                        if distanceY > 0 {
                            bottomView.origin?.y = positionY
                            rectangleView.height = distanceY
                            bottomView.height = self.frame.height - positionY
                        }
                        else{
                            rectangleView.origin?.y = positionY
                            rectangleView.height -= distanceY
                            topView.height = positionY
                        }
                        leftView.height = rectangleView.height
                        rightView.height = rectangleView.height
                    }
                    else{
                        var yCorner:CGFloat = positionY - (initialHeightWidth/2)
                        let xCorner:CGFloat = positionX - (initialHeightWidth/2)
                        var rectangleHeight:CGFloat = initialHeightWidth
                        if yCorner < 0{
                            rectangleHeight = initialHeightWidth + yCorner
                            yCorner = 0
                        }
                        else if yCorner + initialHeightWidth > self.frame.height{
                            rectangleHeight = self.frame.height - yCorner
                        }
            
                    
                        rectangleView.changeWholeRectangle(origin: CGPointMake(xCorner, yCorner), width: initialHeightWidth,    height: rectangleHeight)
                        topView.changeWholeRectangle(origin: CGPointMake(0, 0), width: self.frame.width, height: yCorner)
                        bottomView.changeWholeRectangle(origin: CGPointMake(0, yCorner+rectangleHeight),
                                                    width: self.frame.width, height: self.frame.height-rectangleHeight-yCorner)
                        leftView.changeWholeRectangle(origin: CGPointMake(0, yCorner),
                                                  width: positionX-initialHeightWidth/2, height: rectangleHeight)
                        rightView.changeWholeRectangle(origin: CGPointMake(positionX+initialHeightWidth/2, yCorner),
                                                   width: self.frame.width-positionX-initialHeightWidth/2, height: rectangleHeight)
                    
                    }
                    rectangleView.updateRectangle()
                    topView.updateRectangle()
                    bottomView.updateRectangle()
                    leftView.updateRectangle()
                    rightView.updateRectangle()
                }
            }
        default:
            print(1)
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(touches)
    }
}
