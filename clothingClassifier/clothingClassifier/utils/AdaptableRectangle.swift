//
//  AdaptableRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 17-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class AdaptableRectangle: UIImageView {
    
    struct Rectangle {
        var width:CGFloat = 0
        var height:CGFloat = 0
        var origin:CGPoint?
        var rectangleView:UIView!
        
        func updateRectangle(){
            rectangleView.frame = CGRectMake(origin!.x, origin!.y, width, height)
        }
        
        mutating func changeWholeRectangle(origin origin:CGPoint?, width:CGFloat, height:CGFloat){
            self.origin = origin
            self.width = width
            self.height = height
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
                let positionY:CGFloat = position.y
                let positionX:CGFloat = position.x
                if let origin = rectangleView.origin{
                    let distanceX:CGFloat = positionX - origin.x
                    let distanceY:CGFloat = positionY - origin.y
                    
                    if distanceX > 0{
                        rectangleView.width = distanceX
                        rightView.origin?.x = positionX
                        rightView.width -= (distanceX - rectangleView.width)
                    }
                    else{
                        rectangleView.width -= distanceX
                        rectangleView.origin?.x = positionX
                        leftView.width = positionX
                    }
                    
                    if distanceY > 0 {
                        rectangleView.height = distanceY
                        bottomView.origin?.y = positionY
                        bottomView.height -= (distanceY - rectangleView.height)
                    }
                    else{
                        rectangleView.height -= distanceY
                        rectangleView.origin?.y = positionY
                        topView.height = positionY
                    }
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
            
                    
                    rectangleView.changeWholeRectangle(origin: CGPointMake(xCorner, yCorner), width: initialHeightWidth, height: rectangleHeight)
                    topView.changeWholeRectangle(origin: CGPointMake(0, 0), width: self.frame.width, height: yCorner)
                    bottomView.changeWholeRectangle(origin: CGPointMake(0, yCorner+rectangleHeight),
                                                    width: self.frame.width, height: self.frame.height-rectangleHeight-yCorner)
                    leftView.changeWholeRectangle(origin: CGPointMake(0, yCorner),
                                                  width: positionX-initialHeightWidth/2, height: rectangleHeight)
                    rightView.changeWholeRectangle(origin: CGPointMake(positionX+initialHeightWidth/2, yCorner),
                                                   width: self.frame.width-positionX-initialHeightWidth/2, height: rectangleHeight)
                    

                }
                
                topView.updateRectangle()
                bottomView.updateRectangle()
                leftView.updateRectangle()
                rightView.updateRectangle()
                rectangleView.updateRectangle()
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
