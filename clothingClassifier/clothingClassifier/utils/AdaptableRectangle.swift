//
//  AdaptableRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 17-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class AdaptableRectangle: UIImageView {
    private var adapter: RectangleAdapter!
    private var isSliding = false
    private let initialHeightWidth : CGFloat = 100
    private let borderWidth : CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        let originXCropper = CGRectGetMidX(self.frame) - initialHeightWidth/2
        let originYCropper = CGRectGetMidY(self.frame) - initialHeightWidth/2
        let cropperRect = CGRectMake(originXCropper, originYCropper, initialHeightWidth, initialHeightWidth)
        adapter = RectangleAdapter(forView: self, withCropperRect: cropperRect)
    }
    
    
    convenience init(withImageView imageView: UIImageView){
        self.init(frame: imageView.frame)
        self.image = imageView.image
        self.contentMode = imageView.contentMode
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.userInteractionEnabled = true
        let originXCropper = self.center.x - initialHeightWidth/2
        let originYCropper = self.center.y - initialHeightWidth/2
        let cropperRect = CGRectMake(originXCropper, originYCropper, initialHeightWidth, initialHeightWidth)
        adapter = RectangleAdapter(forView: self, withCropperRect: cropperRect)

    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let point = touch.locationInView(self)
            adapter.updateRectangles(forPoint: point)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let previousPoint = touch.previousLocationInView(self)
            let currentPoint = touch.locationInView(self)
            adapter.moveCentralRectangle(fromPoint: previousPoint, to: currentPoint)
        }
    }
}
