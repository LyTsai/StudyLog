//
//  ViewController.swift
//  Demo_testUI
//
//  Created by iMac on 17/3/31.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shield = ["Sleep - 8 hours", "Handle – Manage Stres", "Interact -Socialize", "Exercise -8000 steps", "Learn -New Things", "Diet -Mediterranean/Veg"]
        let detail = ["You should strive for eight hours of shuteye per night. If you can’t get it done continuously, take naps.", "Don’t let stress overwhelm you.", "Stay social. Loneliness is a stress factor.", "It removes inflammation and plaque from the brain. Working out also causes new nerve cells to be born in the hippocampus—the battle zone for Alzheimer’s.", "The more synapses you make, the more you can lose before you lose it.", "The Mediterranean Diet, which is high in fruits, vegetables, olive oil, and whole grains and involves eating proteins occasionally, is best for your brain-  your diet, and its effect on your microbiome, matters a lot as it has a profound effect on neuroinflammation."]
        let table = StretchExplainTableView(frame: CGRect(x: 0, y: 40, width: 315, height: 330), style: .grouped)
        table.setupWithFrame(CGRect(x: 0, y: 40, width: 315, height: 330), titles: shield, texts: detail)
        self.view.addSubview(table)
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
