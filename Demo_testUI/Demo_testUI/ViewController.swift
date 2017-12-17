//
//  ViewController.swift
//  Demo_testUI
//
//  Created by iMac on 17/3/31.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var transformView: TransformView!
    override func awakeFromNib() {
        print("2")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("1")
        
        let t = UIView(frame: transformView.frame)
        t.backgroundColor = UIColor.red
        view.insertSubview(t, belowSubview: transformView)
        
        
        transformView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        transformView.center = CGPoint(x: t.center.x, y: t.frame.maxY)

        
        transformView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 6))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("vc layout")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return CGFloat(M_PI * 2) / CGFloat(numberOfItems)
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
    
    
    // rotation
    /*
     fileprivate var rAngle: CGFloat = 0
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     let currentPoint = touches.first!.location(in: self)
     
     let lastPoint = touches.first!.previousLocation(in: self)
     let angle = Calculation().angleOfPoint(currentPoint, center: viewCenter) - Calculation().angleOfPoint(lastPoint, center: viewCenter)
     transform = transform.rotated(by: angle)
     rAngle += angle
     
     var index = 0
     let total = rAngle / angleGap
     index = (total > 0 ? Int(total + 0.5) : Int(total - 0.5)) % numberOfSlices
     index = (index > 0 ? (numberOfSlices - index) : -index)
     
     selectedIndex = index
     }
     
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     adjustAngle()
     }
     override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
     adjustAngle()
     }
     
     // scroll to center
     fileprivate func adjustAngle() {
     var adjust: CGFloat = 0
     
     let turn = rAngle.truncatingRemainder(dividingBy: angleGap)
     if abs(turn) <= angleGap * 0.5 {
     // still this slice selected
     adjust = -turn
     }else {
     // next one is selected
     if turn > 0 {
     adjust = angleGap - turn
     }else {
     adjust = -angleGap - turn
     }
     }
     
     transform = transform.rotated(by: adjust)
     rAngle += adjust
     }
     */
}
