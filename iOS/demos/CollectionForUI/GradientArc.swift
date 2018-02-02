//
//  CoreGraphicsAndDrawRect.swift
//  UIDesignCollection
//
//  Created by Lydire on 16/9/7.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import UIKit

// http://blog.csdn.net/zhoutao198712/article/details/20864143

class GradientArc: UIView {

    // MARK: transfer units
    func degreeToRadians(_ radians: CGFloat) -> CGFloat {
        return radians * CGFloat(M_PI) / 180
    }
    
    func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0, blue: CGFloat((rgbValue & 0xFF) >> 16) / 255.0, alpha: 1)
    }
    
    // MARK: ------------ draw methods
    // CAShapeLayer
    // create a trackLayer object and add it to the view's layer
    func drawBackgroundArcWithPath(_ path: UIBezierPath) {
        let trackLayer = CAShapeLayer() // [CAShapeLayer layer]
        trackLayer.frame = bounds
        layer.addSublayer(trackLayer)
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.green.cgColor // path的渲染颜色
        trackLayer.opacity = 0.25
        trackLayer.lineCap = kCALineCapRound // string, not enum
        trackLayer.lineWidth = 15
        trackLayer.path = path.cgPath
        /* up till now, draws a path as bezierPath does, with
         stroke: strokeColor.colorWithAlphaComponent(opacity) and
         fill: fillColor.colorWithAlphaComponent(opacity)*/
        // 把path传递给layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    }
    
    
    func createMaskLayerWithPath(_ path: UIBezierPath, percent: CGFloat, animated: Bool) -> CAShapeLayer  {
        let progressLayer = CAShapeLayer() // [CAShapeLayer layer]
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.green.cgColor
        progressLayer.lineCap = kCALineCapRound
        progressLayer.lineWidth = 15
        progressLayer.path = path.cgPath
        
        // TODO: set animation, but did not work
        CATransaction.begin()
        CATransaction.setDisableActions(animated) // 有个 disableActions() 方法，得到其Bool值
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
        CATransaction.setAnimationDuration(30)
        
        progressLayer.strokeEnd = percent // path的结尾处，1代表画完，0不画————所以，其实path的轨迹方向很重要。同时有个：public var strokeStart: CGFloat
        /* These values define the subregion of the path used to draw the troked outline. The values must be in the range [0,1] with zero representing the start of the path and one the end. Values in  between zero and one are interpolated linearly along the path length. strokeStart defaults to zero and strokeEnd to one. Both are animatable.（可以动态的表示进度的变化） */
        CATransaction.commit()
        
        return progressLayer
        
    }
    
    // CAGradientLayer
    // CAGradientLayer是一个用来画颜色渐变的层（如果使用透明的颜色，也就可以做到透明渐变）。CAShapeLayer只能指定两个点之间进行渐变，这里采用了左右两边分别竖着渐变的方法来达到弧线渐变的效果。
    func addGradientLayerWithMaskLayer(_ progressLayer: CAShapeLayer)  {
        let gradientLayer = CALayer()
        let middleColor = UIColorFromRGB(0xfde802).cgColor
        
        // left part
        let gradientLayer1 = CAGradientLayer() // [CAGradientLayer layer]
        gradientLayer1.frame = CGRect(x: 0, y: 0, width: bounds.width * 0.5, height: bounds.height)
        gradientLayer1.colors = [UIColor.red.cgColor, middleColor]  // [AnyObject]?, The array of CGColorRef objects defining the color of each gradient stop. Defaults to nil. Animatable.
        
        gradientLayer1.locations = [0.5, 0.9, 1] // [NSNumber]?, An optional array of NSNumber objects defining the location of each radient stop as a value in the range [0,1]. The values must be monotonically increasing. If a nil array is given, the stops are assumed to spread uniformly across the [0,1] range. When rendered, the colors are mapped to the output colorspace before being interpolated. Defaults to nil. Animatable.
        
        gradientLayer1.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer1.endPoint = CGPoint(x: 0.5, y: 0)/* Both points are defined in a unit coordinate space that is then mapped to the layer's bounds rectangle when drawn. The default values are [.5,0] and [.5,1] respectively(画出来是从上到下竖直方向变化). Both are animatable. */
    
        // right part
        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.frame = CGRect(x: bounds.midX, y: 0, width: bounds.width * 0.5, height: bounds.height)
        gradientLayer2.colors = [middleColor, UIColor.blue.cgColor]
        gradientLayer2.locations = [0.1, 0.5, 1]
        gradientLayer2.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer2.endPoint = CGPoint(x: 0.5, y: 1)
        
        // add to the layer
        gradientLayer.addSublayer(gradientLayer1)
        gradientLayer.addSublayer(gradientLayer2)
        
        gradientLayer.mask = progressLayer
        layer.addSublayer(gradientLayer)
    }
    
    // MARK: ------------ drawRect
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 300, startAngle: degreeToRadians(150), endAngle: degreeToRadians(30), clockwise: true)
        
        drawBackgroundArcWithPath(path)                     // 1. background arc
        
        let  progressLayer = createMaskLayerWithPath(path, percent: 0.85, animated: true)  // 2. progress prepared
        
        addGradientLayerWithMaskLayer(progressLayer)        // 3. gradient and mask: foreground colors
    }

}
