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
     
        print(isPhoneNumber("1223455698766544"))
        print(isPhoneNumber("1228766545"))
        print(isPhoneNumber("12287665489t987t9605"))
        print(isPhoneNumber("12287665ry6ej87i45"))
        print(isPhoneNumber("122876777089686545"))
    }
    
   
    func isPhoneNumber(_ string: String) -> Bool {
        let phoneRegex = "^\\d{10}?$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@",phoneRegex)
        
        return phoneTest.evaluate(with: string)
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
