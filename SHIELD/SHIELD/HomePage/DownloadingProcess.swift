//
//  DownloadingProcess.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/9/28.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class DownloadingBarProcess {
    fileprivate var timer: Timer!
    fileprivate let processBar = CAGradientLayer()
    fileprivate let processMask = CAShapeLayer()
    fileprivate var paused = false
    
    class func createWithFrame(_ frame: CGRect, onView view: UIView, dValue: CGFloat) -> DownloadingBarProcess {
        let process = DownloadingBarProcess()
        process.dValue = dValue
        process.addProcessFrame(frame, onView: view)

        return process
    }
    
    fileprivate var dValue: CGFloat = 0.03
    fileprivate var value: CGFloat = 0 {
        didSet{
            processMask.strokeEnd = value
        }
    }
    func addProcessFrame(_ frame: CGRect, onView view: UIView) {
        processBar.frame = frame
        processBar.colors = [UIColorFromHex(0x99E8F9).cgColor, UIColorFromHex(0x22A8EA).cgColor]
        processBar.borderColor = UIColorFromHex(0x22A8EA).cgColor
        processBar.borderWidth = fontFactor
        processMask.lineWidth = frame.height
        
        let strokePath = UIBezierPath()
        strokePath.move(to: CGPoint(x: 0, y: frame.height * 0.5))
        strokePath.addLine(to: CGPoint(x: frame.width, y: frame.height * 0.5))
        processMask.strokeColor = UIColor.red.cgColor
        processMask.path = strokePath.cgPath
        processBar.mask = processMask
        
        // shadow
        processBar.addBlackShadow(3 * fontFactor)
        processBar.shadowColor = UIColorGray(53).cgColor
        processBar.shadowOpacity = 0.7
        
        view.layer.addSublayer(processBar)
        
        // timer to start
        startProcess()
    }
    
    // finished
    var endTimeInterval: TimeInterval {
        return TimeInterval(Int(0.25 / 0.05) + 1) * 0.05 + 0.3
    }
    func processIsFinished(_ completion: (()->Void)?) {
        if !paused {
            // not paused before, force to end
            UIView.animate(withDuration: endTimeInterval - 0.3, animations: {
                self.value = 1
            }, completion: { (true) in
                self.timer.invalidate()
            })
        }else {
            timer.fireDate = Date()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + endTimeInterval, execute: {
            self.endProcess()
            completion?()
        })
    }
    
    // process
    // pause
    func pauseProcess() {
        paused = true
        timer.fireDate = Date.distantFuture
    }
    
    func keepProcess()  {
        paused = false
        timer.fireDate = Date()
    }
    
    // restart
    func startProcess()  {
        self.value = 0
        paused = false
        if timer != nil {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            if self.value < 0.4 {
                self.value += self.dValue
            }else {
                self.value += self.dValue * 0.45
                if self.value > 0.85 && !self.paused {
                    self.pauseProcess()
                }
            }
            
            // end
            if self.value >= 1 {
                timer.invalidate()
            }
        })
    }
    
    // end and remove
    func endProcess() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        processBar.removeFromSuperlayer()
    }
}

