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
        // Do any additional setup after loading the view, typically from a nib.
        
        var views = [UIButton]()
        
        for _ in 0..<10 {
            let test = UIButton()
            test.backgroundColor = UIColor.cyan
            views.append(test)
            
        }
        
        let menu = CarouselMenuView()
        menu.setupWithFrame(CGRect(x: 20, y: 100, width: 250, height: 220), items: views, ovalRatio: 1.5)
        view.addSubview(menu)
        
//        view.backgroundColor = UIColor.lightGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class CarouselMenuView: UIView {
    var items = [UIButton]()
    var selectedIndex = 0
    
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
        let scale: CGFloat = 0.8
        
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
        
    }
    
}
