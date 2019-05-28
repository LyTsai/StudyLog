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
        
        let test = TestView(frame: view.bounds)
        test.backgroundColor = UIColor.white
        view.addSubview(test)
    }
    

    @IBAction func actionForButton(_ sender: Any) {
//        let vc = AbookHintViewController()
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        vc.focusOnFrame(CGRect(x: 40, y: 160, width: 100, height: 200), hintText: "this is a test string") 
//        present(vc, animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
}

class TestView: UIView {
    var startPoint = CGPoint.zero
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPoint = touches.first!.location(in: self)
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPoint = touches.first!.location(in: self)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: CGPoint.zero)
        
        UIColor.red.setStroke()
        path.lineWidth = 5
        path.stroke()
    }
}

