//
//  ViewController.swift
//  Demo_testUI
//
//  Created by iMac on 17/3/31.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import UIKit
import WebKit

extension UIBezierPath {
    class func pathWithAttributedString(_ attributedString: NSAttributedString, maxWidth: CGFloat) -> UIBezierPath {
        let letters = CGMutablePath()

        // CTLine
        let line = CTLineCreateWithAttributedString(attributedString as CFAttributedString)
        // CFArray
        let runArray = CTLineGetGlyphRuns(line)
        for runIndex in 0..<CFArrayGetCount(runArray) {
            let run = CFArrayGetValueAtIndex(runArray, runIndex)
            let runBit = unsafeBitCast(run, to: CTRun.self)
            let CTFontName = unsafeBitCast(kCTFontAttributeName, to: UnsafeRawPointer.self)
            
            let runFontC = CFDictionaryGetValue(CTRunGetAttributes(runBit),CTFontName)
            let runFontS = unsafeBitCast(runFontC, to: CTFont.self)

            for i in 0..<CTRunGetGlyphCount(runBit) {
                let range = CFRangeMake(i, 1)
                let glyph = UnsafeMutablePointer<CGGlyph>.allocate(capacity: 1)
                glyph.initialize(to: 0)
                let position = UnsafeMutablePointer<CGPoint>.allocate(capacity: 1)
                position.initialize(to: .zero)
                CTRunGetGlyphs(runBit, range, glyph)
                CTRunGetPositions(runBit, range, position);
                
                if let path = CTFontCreatePathForGlyph(runFontS,glyph.pointee,nil) {
                    let transform = CGAffineTransform(translationX: position.pointee.x, y: position.pointee.y)
                    letters.addPath(path, transform: transform)
                }
                glyph.deinitialize(count: 1)
                glyph.deallocate()
                
                position.deinitialize(count: 1)
                position.deallocate()
            }
        }
        
        let path = UIBezierPath(cgPath: letters)
        return path
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let shape = CAShapeLayer()
        shape.path = getDownArrowBubblePathWithMainFrame(CGRect(x: 80, y: 80, width: 300, height: 100), arrowPoint: CGPoint(x: 200, y: 200), radius: 6).cgPath
        shape.strokeColor = UIColor.red.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = 5
        view.layer.addSublayer(shape)
    }
    
   
    func getDownArrowBubblePathWithMainFrame(_ rect: CGRect, arrowPoint: CGPoint, radius: CGFloat) -> UIBezierPath {
        let innerRect = rect.insetBy(dx: radius, dy: radius)
        let arrowL = (arrowPoint.y - rect.maxY) * 0.6
        
        // path
        let bubblePath = UIBezierPath(arcCenter: innerRect.origin, radius: radius, startAngle: -CGFloatPi * 0.5, endAngle: CGFloatPi, clockwise: false)
        bubblePath.addLine(to: CGPoint(x: rect.minX, y: innerRect.maxY))
        bubblePath.addArc(withCenter: innerRect.bottomLeftPoint, radius: radius, startAngle: CGFloatPi, endAngle: CGFloatPi * 0.5, clockwise: false)
        bubblePath.addLine(to: CGPoint(x: arrowPoint.x - arrowL, y: rect.maxY))
        bubblePath.addLine(to: arrowPoint)
        bubblePath.addLine(to: CGPoint(x: arrowPoint.x + arrowL, y: rect.maxY))
        bubblePath.addLine(to: CGPoint(x: innerRect.maxX, y: rect.maxY))
        bubblePath.addArc(withCenter: innerRect.bottomRightPoint, radius: radius, startAngle: CGFloatPi * 0.5, endAngle: 0, clockwise: false)
        bubblePath.addLine(to: CGPoint(x: rect.maxX, y: innerRect.minY))
        bubblePath.addArc(withCenter: innerRect.topRightPoint, radius: radius, startAngle: 0, endAngle: -CGFloatPi * 0.5, clockwise: false)
        bubblePath.close()
        return bubblePath
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
