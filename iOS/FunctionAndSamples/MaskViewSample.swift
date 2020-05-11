//
//  MaskViewUsageView.swift
//  Demo_testUI
//
//  Created by iMac on 2017/9/8.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// maskView: An optional view whose alpha channel is used to mask a view’s content.
/*
 最终效果图怎么显示只跟maskView每个point的alpha相关，透明度一致。
 */

class MaskViewUsageView: UIView {
    let maskLayer = CALayer()
    let imageView1 = UIImageView(image: #imageLiteral(resourceName: "base"))
    let imageView2 = UIImageView(image: #imageLiteral(resourceName: "background"))
    
    var demoTag = 0
    // set up
    // 点击的地方为中心，一圈区域出现上面的图
    func demoOne() {
        demoTag = 1
        
        backgroundColor = UIColor.cyan
        
        maskLayer.contents = UIImage(named: "icon2")?.cgImage
        // 可以用一个边缘羽化的图片，这样会出来一个边上渐隐的效果。因为maskLayer的透明部分会继续遮挡。
//        maskLayer.backgroundColor = UIColor.red.cgColor
        imageView2.layer.mask = maskLayer
        addSubview(imageView2)
        
        // frames
        imageView2.frame = bounds
        
        maskLayer.frame = CGRect(x: 20, y: 10, width: 100, height: 100)
        maskLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        if demoTag == 1 {
            maskLayer.position = point!
        }
    }
    
    // 两个图片的交叉切换显示
    func demoTwo() {
        imageView1.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView1.center = self.center
        addSubview(imageView1)
        
        imageView2.frame = imageView1.frame
        addSubview(imageView2)
        
        let maskView = UIView(frame: imageView1.bounds)
        imageView2.mask = maskView
        
        let pic1 = UIImageView(image: #imageLiteral(resourceName: "mask1"))
        pic1.frame = CGRect(x: 0, y: 0, width: 100, height: 400)
        maskView.addSubview(pic1)
        
        let pic2 = UIImageView(image: #imageLiteral(resourceName: "mask"))
        pic2.frame = CGRect(x: 100, y: -200, width: 100, height: 400)
        maskView.addSubview(pic2)
        
        // imageView1 will shows, imageView2's mask is total clear
        UIView.animate(withDuration: 5, delay: 4, options: .curveEaseInOut, animations: {
            pic1.center = CGPoint(x: pic1.center.x, y: pic1.center.y - 400)
            pic2.center = CGPoint(x: pic2.center.x, y: pic2.center.y + 400)
        }, completion: nil)
    }
    
    // 滑动来解锁
    let unlock = UILabel()
    func demoThree()  {
        // gradient，默认从上到下
        let gradientLayer = CAGradientLayer()
        layer.addSublayer(gradientLayer)
        gradientLayer.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 64)
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.25, 0.5, 0.75]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        // animation
        let basicAnimation = CABasicAnimation(keyPath: "locations")
        basicAnimation.fromValue = [0, 0, 0.25]
        basicAnimation.toValue = [0.75, 1, 1]
        basicAnimation.duration = 2.5
        basicAnimation.repeatCount = 100
        gradientLayer.add(basicAnimation, forKey: nil)
        
        // textLabel
        // MARK:----------------- 这里的label，必须是强引用，否则不会出现。因为方法调用完加载之后，label被销毁了就（这个label不是子视图）。
        /*
         当一个控件(UIiew,UIlabel,UIbutton)创建时,系统会自动创建一个与之相对应的layer，layer怎么显示，实际是与之对应的控件相关的，layer与之对应的控件是delegate关系，即layer.delegate=当前控件，在系统创建layer之后，layer的delegate会执行 - (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context 方法绘制图层来显示给用户看，当控件销毁了，则不会执行此方法了，那么layer上什么也没有，又因为控件创建的默认色为clearColor(如果设置了backgroundColor为不透明，则layer也会不透明),那么layer也会全透明(UIImageView比较特殊，除外)。在此例中如果不强引用保存unlock，执行完viewDidload方法后unlock就会销毁，如果unlock销毁了，那么unlock相对的layer就是全透明，那么gradientLayer也会全透明，即不强引用unlock的最终显示效果是 屏幕上什么都看不见。
         */
        unlock.frame = gradientLayer.bounds
        unlock.text = "滑动来解锁 >>"
        unlock.textAlignment = .center
        unlock.font = UIFont.boldSystemFont(ofSize: 30)
        unlock.alpha = 0.5
        
        // mask
        gradientLayer.mask = unlock.layer
    }
}
