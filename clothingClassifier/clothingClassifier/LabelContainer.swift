//
//  LabelContainer.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 07-11-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class LabelContainer: UIView {
    private var rightEdge:UIView!
    private var leftEdge:UIView!
    private var topEdge:UIView!
    private var bottomEdge:UIView!
    private var labelView:UIView!
    private let margin:CGFloat = 8

    init(frame: CGRect, withColor color:UIColor, withEdgeWidth edgeWidth:CGFloat, withText text:String,
         andTextColor textColor:UIColor) {
        super.init(frame: frame)
        initEdges(frame: frame, withEdgeWidth: edgeWidth)
        setEdgesColor(color: color)
        setLabelView(withText: text, textColor: textColor, andBackgroundColor: color)
    }
    
    private func setLabelView(withText text:String, textColor:UIColor, andBackgroundColor color:UIColor){
        let label = UILabel(frame: CGRect.zero)
        label.textColor = textColor
        label.text = text
        label.font = label.font.withSize(8)
        label.numberOfLines = 0
        label.sizeToFit()
        let labelWidth = label.frame.width
        let labelHeight = label.frame.height
        labelView = UIView(frame: CGRect(x: 0, y: 0, width: labelWidth+2*margin, height: labelHeight+2*margin))
        labelView.backgroundColor = color
        labelView.addSubview(label)
        labelView.bringSubview(toFront: label)
        label.frame.origin = CGPoint(x: margin, y: margin)
        self.addSubview(labelView)
    }
    
    private func setEdgesColor(color:UIColor){
        rightEdge.backgroundColor = color
        leftEdge.backgroundColor = color
        topEdge.backgroundColor = color
        bottomEdge.backgroundColor = color
    }
    
    private func initEdges(frame:CGRect, withEdgeWidth edgeWidth:CGFloat){
        let height = frame.height
        let width = frame.width
        rightEdge = UIView(frame: CGRect(x: 0, y: 0, width: edgeWidth, height: height))
        leftEdge = UIView(frame: CGRect(x: width, y: 0, width: edgeWidth, height: height))
        topEdge = UIView(frame: CGRect(x: 0, y: 0, width: width, height: edgeWidth))
        bottomEdge = UIView(frame: CGRect(x: 0, y: height, width: width, height: edgeWidth))
        self.addSubview(rightEdge)
        self.addSubview(leftEdge)
        self.addSubview(topEdge)
        self.addSubview(bottomEdge)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initEdges(frame: CGRect.zero, withEdgeWidth: 0)
    }

}
