//
//  AbookHintViewController.swift
//  AnnielyticX
//
//  Created by L on 2019/4/16.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class AbookHintViewController: UIViewController {
    var blankAreaIsTouched: (()-> Void)?
    var hintKey = ""
    
    fileprivate let hintImage = UIImageView(image: UIImage(named: "homeHintBack"))
    fileprivate let hintLabel = UILabel()
    fileprivate let tapHint = UIImageView(image: UIImage(named: "homeTap") )
    fileprivate let backLayer = CAShapeLayer()
    fileprivate let nevershow = GradientBackStrokeButton(type: .custom)
    fileprivate let dismiss = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        backLayer.fillColor = UIColor.black.withAlphaComponent(0.5).cgColor

        hintLabel.numberOfLines = 0
        hintLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)

        // add back
        backLayer.addBlackShadow(8 * fontFactor)
        backLayer.shadowOffset = CGSize.zero
        
        view.layer.addSublayer(backLayer)
        
        // add others
        view.addSubview(hintImage)
        view.addSubview(hintLabel)
        view.addSubview(tapHint)
        
        // never show hint
        nevershow.setupWithTitle("Never Show")
        nevershow.isSelected = false
        nevershow.isUserInteractionEnabled = false
        view.addSubview(nevershow)
        
        dismiss.setBackgroundImage(UIImage(named: "dismiss_white"), for: .normal)
//        dismiss.addTarget(self, action: #selector(dimis), for: .touchUpInside)
        view.addSubview(dismiss)
    }
    
    fileprivate var focusArea = CGRect.zero
    func focusOnFrame(_ focusArea: CGRect, hintText: String) {
        self.focusArea = focusArea
        hintLabel.text = hintText
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
        var left: CGFloat = 0
        var bottom: CGFloat = 0
        if #available(iOS 11, *) {
            let window = (UIApplication.shared.delegate as! AppDelegate).window
            left = window!.safeAreaInsets.left
            bottom = window!.safeAreaInsets.bottom
        }
        
        // back
        let path = UIBezierPath(ovalIn: focusArea)
        path.append(UIBezierPath(rect: view.bounds))
        backLayer.fillRule = .evenOdd
        backLayer.path = path.cgPath
        
        // frames
        // back image
        var hintImageY = min(focusArea.maxY + 65 * fontFactor, height - bottom - 160 * fontFactor)
        if hintImageY < focusArea.minY {
            hintImageY = focusArea.minY - 180 * fontFactor
        }
        hintImage.frame = CGRect(x: left, y: hintImageY, width: 374 * fontFactor, height: 210 * fontFactor)
        
        // label
        hintLabel.frame = CGRect(x: hintImage.frame.minX + 112 * fontFactor, y: hintImage.frame.minY + 4 * fontFactor, width: 244 * fontFactor, height: 92 * fontFactor)
        
        // button
        let buttonSize = CGSize(width: 90 * fontFactor, height: 40 * fontFactor)
        nevershow.frame = CGRect(x: hintLabel.frame.maxX - buttonSize.width, y: hintImage.frame.midY, width: buttonSize.width, height: buttonSize.height)
        dismiss.frame = CGRect(center: CGPoint(x: hintImage.frame.maxX - 45 * fontFactor, y: hintImage.frame.minY - 42 * fontFactor), length: 40 * fontFactor)
        
        // hand
        let handSize = CGSize(width: 108 * fontFactor, height: 78 * fontFactor)
        tapHint.frame = CGRect(x: min(focusArea.midX, width - handSize.width), y: max(focusArea.minY - handSize.height * 0.95, 0), width: handSize.width, height: handSize.height)
    }
    
    
    func addAttributes(_ attributes: [NSAttributedString.Key : Any], range: NSRange) {
        if let text = hintLabel.text {
            let attributedText = NSMutableAttributedString(string: text, attributes: [:])
            attributedText.addAttributes(attributes, range: range)
            hintLabel.attributedText = attributedText
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: view)
        if focusArea.contains(location) {
            dismiss(animated: true) {
                self.blankAreaIsTouched?()
            }
        }else {
            if nevershow.frame.contains(location) {
                userDefaults.set(true, forKey: hintKey)
                userDefaults.synchronize()
            }
            dismiss(animated: true, completion: nil)
        }
    }
    

    fileprivate var timer: Timer!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if timer == nil {
            var count = 0
            let alph = 4 * fontFactor
            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (timer) in
                self.tapHint.transform = CGAffineTransform(translationX: 0, y: count % 2 == 0 ? -alph : alph)
                count += 1
                if count == 2 {
                    count = 0
                }
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
}
