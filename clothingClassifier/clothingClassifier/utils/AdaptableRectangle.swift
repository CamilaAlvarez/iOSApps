//
//  AdaptableRectangle.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 17-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class AdaptableRectangle: UIImageView {
    fileprivate var adapter: RectangleAdapter!
    fileprivate var isSliding = false
    fileprivate let initialHeightWidth : CGFloat = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        let originXCropper = self.frame.midX - initialHeightWidth/2
        let originYCropper = self.frame.midY - initialHeightWidth/2
        let cropperRect = CGRect(x: originXCropper, y: originYCropper, width: initialHeightWidth, height: initialHeightWidth)
        adapter = RectangleAdapter(forView: self, withCropperRect: cropperRect)
        
    }
    
    func getCroppedRect()->CGRect{
        return adapter.getCentralRectangle()
    }
    
    convenience init(withImageView imageView: UIImageView){
        self.init(frame: imageView.frame)
        self.image = imageView.image
        self.contentMode = imageView.contentMode
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
        let originXCropper = self.center.x - initialHeightWidth/2
        let originYCropper = self.center.y - initialHeightWidth/2
        let cropperRect = CGRect(x: originXCropper, y: originYCropper, width: initialHeightWidth, height: initialHeightWidth)
        adapter = RectangleAdapter(forView: self, withCropperRect: cropperRect)

    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let point = touch.location(in: self)
            adapter.updateRectangles(forPoint: point)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let previousPoint = touch.previousLocation(in: self)
            let currentPoint = touch.location(in: self)
            adapter.moveCentralRectangle(fromPoint: previousPoint, to: currentPoint)
        }
    }
}
