//
//  ViewController.swift
//  Demo_testUI
//
//  Created by iMac on 17/3/31.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var a: UITextField!
    @IBOutlet weak var b: UITextField!
    @IBOutlet weak var c: UITextField!
    @IBOutlet weak var d: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //3， 10， 9
       
    }
    
    
    @IBAction func calculate(_ sender: Any) {
        let score = Float(b.text!)! - Float(a.text!)!
        let abc = Float(d.text!)! - Float(c.text!)!
        
        print(score/abc)
        
    }
    func showViewFromTop() {
        let arrowMaskLayer = CAShapeLayer()
        view.layer.mask = arrowMaskLayer
        let arrowW = view.bounds.width
        arrowMaskLayer.backgroundColor = UIColor.clear.cgColor
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: arrowW * 0.5, y: 0))
        path.addLine(to: CGPoint(x: arrowW * 0.5, y: view.bounds.maxY))
        arrowMaskLayer.strokeColor = UIColor.red.cgColor
        arrowMaskLayer.lineWidth = arrowW
        
        arrowMaskLayer.path = path.cgPath
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = 3
        basicAnimation.fromValue = 0
        basicAnimation.toValue = 1
        arrowMaskLayer.add(basicAnimation, forKey: nil)
    }
}


// one menu item
/*
 class CarouselItemView: UIView {
 // image, text and so on
 }
 */


// carousel-like menu
class CarouselMenuView: UIView {
    var items = [UIButton]()
    var selectedIndex = 0
    var scale: CGFloat = 0.8
    
    
    var numberOfItems: Int {
        return items.count
    }
    var angleGap: CGFloat {
        return CGFloat(Double.pi * 2) / CGFloat(numberOfItems)
    }
    
    func setupWithFrame(_ frame: CGRect, items: [UIButton], ovalRatio: CGFloat) {
        backgroundColor = UIColor.lightGray
        self.frame = frame
        self.items = items
        let ratio = ovalRatio < 1 ? 1.25 : ovalRatio
        
        // no view
        if numberOfItems == 0 {
            return
        }
        
        // calculation
        let centerX = bounds.midX
        let centerY = bounds.midY
        
        let itemLength = bounds.width / (CGFloat(numberOfItems / 2) + 1)
        
        let ovalA = (bounds.width - itemLength) * 0.5
        let ovalB = ovalA / ratio
        
        for (i, item) in items.enumerated() {
            let floatI = CGFloat(i)
            item.tag = 100 + i
            
            let angle = CGFloat(M_PI_2) + angleGap * floatI
            let radius = 1.0 / sqrt(cos(angle) * cos(angle) / (ovalA * ovalA) + sin(angle) * sin(angle) / (ovalB * ovalB))
            
            let tempY = centerY + radius * cos(angleGap * floatI)
            let tempX = centerX + radius * sin(angleGap * floatI)
            item.frame = CGRect(x: tempX - itemLength * 0.5, y: tempY - itemLength * 0.5, width: itemLength , height: itemLength)
            
            var scaleNumber = fabs( 2 * floatI / CGFloat(numberOfItems) - 1 )
            scaleNumber = (scaleNumber < 0.3) ? 0.4 : scaleNumber
            item.transform = CGAffineTransform(scaleX: scaleNumber, y: scaleNumber)
            item.addTarget(self, action: #selector(itemClicked(_:)), for: .touchUpInside)
            
            addSubview(item)
        }
        
    }
    
    
    func itemClicked(_ button: UIButton) {
        let item = button.tag - 100
        selectedIndex = item
        
        // go to next view
        
    }
    
    func angleOfPoint(_ a: CGPoint, center c: CGPoint) -> CGFloat {
        return atan2(c.y - a.y, c.x - a.x)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in: self)
        let lastPoint = touches.first!.previousLocation(in: self)
        let angle = angleOfPoint(currentPoint, center: center) - angleOfPoint(lastPoint, center: center)
        transform = transform.rotated(by: angle)
        
        
    }
    
}
