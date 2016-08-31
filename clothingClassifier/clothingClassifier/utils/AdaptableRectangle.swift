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
    private var adapter: RectangleAdapter!
    private var isSliding = false
    private let initialHeightWidth : CGFloat = 100
    private let borderWidth : CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        adapter = RectangleAdapter(forView: self)
    }
    
    
    convenience init(withImageView imageView: UIImageView){
        self.init(frame: imageView.frame)
        self.contentMode = imageView.contentMode
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        adapter = RectangleAdapter(forView: self)
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch touches.count{
        case 1:
            if let touch = touches.first{
                
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
