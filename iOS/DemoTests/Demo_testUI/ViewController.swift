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
     
        let textLayer = CAShapeLayer()
        textLayer.frame = CGRect(x: 100, y: 60, width: 200, height: 400)
        textLayer.fillColor = UIColor.green.cgColor
        textLayer.backgroundColor = UIColor.red.cgColor
        textLayer.path = UIBezierPath.pathWithAttributedString(NSAttributedString(string: "This is a test\nfor more", attributes: [.font: UIFont.systemFont(ofSize: 32 * fontFactor, weight: .medium)]), maxWidth: 200).cgPath
        textLayer.strokeColor = UIColor.black.cgColor
        textLayer.lineWidth = fontFactor
//        textLayer.fillRule = .evenOdd
        textLayer.isGeometryFlipped = true

        view.layer.addSublayer(textLayer)
     
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
