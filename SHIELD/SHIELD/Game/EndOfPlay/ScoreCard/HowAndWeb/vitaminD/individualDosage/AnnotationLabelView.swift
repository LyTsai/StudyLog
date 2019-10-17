//
//  AnnotationLabelView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/17.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class AnnotationLabelView: UIView {
    fileprivate let annotation = UIImageView(image: UIImage(named: "annotation"))
    fileprivate let label = UILabel()
    fileprivate let backLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    fileprivate func addViews() {
        backgroundColor = UIColor.clear
        
        backLayer.strokeColor = UIColor.black.cgColor
        
        label.numberOfLines = 0
        label.textAlignment = .center
        
        
        // add
        layer.addSublayer(backLayer)
        addSubview(label)
        addSubview(annotation)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineWidth = min(bounds.height / 68, bounds.width / 88)
        let annotationH = lineWidth * 36
        annotation.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height - annotationH * 0.5), width: lineWidth * 25, height: annotationH)
        label.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - annotationH).insetBy(dx: lineWidth, dy: 0)
        label.font = UIFont.systemFont(ofSize: 11 * lineWidth)
        
        backLayer.lineWidth = lineWidth
        let backPath = UIBezierPath()
        backPath.move(to: CGPoint.zero)
        backPath.addLine(to: CGPoint(x: 0, y: label.frame.maxY))
        backPath.addLine(to: annotation.center)
        backPath.addLine(to: CGPoint(x: bounds.width, y: label.frame.maxY))
        backPath.addLine(to: CGPoint(x: bounds.width, y: 0))
        backPath.close()
        backLayer.path = backPath.cgPath
    }
    
    func setupWithText(_ text: String, color: UIColor) {
        backLayer.fillColor = color.cgColor
        label.text = text
    }
    
    func pointToLocation(_ location: CGPoint) {
        self.center = CGPoint(x: location.x, y: location.y - frame.height * 0.5)
    }
}
