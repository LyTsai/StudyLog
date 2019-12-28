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
       
        var number = NSNumber(value: 0.0004450)
        print(String(format: "%@", number))
        
        number = NSNumber(value: 1000.00)
        print(String(format: "%@", number))
        number = NSNumber(value: 10.0)
        print(String(format: "%@", number))
        number = NSNumber(value: 0.0)
        print(String(format: "%@", number))
        number = NSNumber(value: 0)
        print(String(format: "%@", number))
        
        
        let barModel = TestResultBar()
        barModel.maxValue = 150
        barModel.normalMin = 15
        barModel.currentValue = 18
        barModel.normalMax = 50
        barModel.step = 15
        
        let testbar = TestResultBarView(frame: CGRect(x: 20, y: 80, width: 500, height: 120))
        testbar.setupWithBar(barModel)
        
        view.addSubview(testbar)
    
    }
    
   
    func isPhoneNumber(_ string: String) -> Bool {
        let phoneRegex = "^\\d{10}?$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@",phoneRegex)
        
        return phoneTest.evaluate(with: string)
    }
    
    
    @IBAction func actionForButton(_ sender: Any) {
 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
}
