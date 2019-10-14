//
//  ReferenceAgeView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/24.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class GetBrainAgeView: UIView {
    weak var reference: BrainAgeReferenceView!
    
    var refValue = 0
    var userKey: String! // for chanage

    fileprivate var displayAge: Int! {
        if let dobString = userCenter.getDobStringOfUser(userKey) {
            let age = CalendarCenter.getAgeFromDateOfBirthString(dobString) ?? 0
            return max(0, refValue + age)
        }else {
            return nil
        }
    }
    
    fileprivate var firstLoad = true
    fileprivate var timer: Timer!
    
    fileprivate let titleLabel = UILabel()
    fileprivate var brainImages = [UIImageView]()
    fileprivate var labels = [UILabel]()
    fileprivate let hintImage = UIImageView(image: UIImage(named: "tapHand"))
    
    fileprivate let pickButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate var mainColor = UIColor.cyan {
        didSet{
            pickButton.layer.borderColor = mainColor.cgColor
            pickButton.layer.shadowColor = mainColor.cgColor
        }
    }
    fileprivate func updateUI() {
        backgroundColor = UIColor.white
        
        // all parts
        titleLabel.textAlignment = .center
        titleLabel.text = "Find out how your brain age compares with your chronological age"
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
       
        // brains
        let titles = ["Younger", "Equal", "Older"]
        for (i, title) in titles.enumerated() {
            let imageView = UIImageView(image: UIImage(named: "brainAge_\(i)"))
            
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.textColor = UIColorGray(144)
            
            brainImages.append(imageView)
            labels.append(label)
            addSubview(imageView)
            imageView.addSubview(label)
        }
        
        // button
        pickButton.backgroundColor = UIColor.white
        pickButton.setTitleColor(UIColorGray(74), for: .normal)
        pickButton.titleLabel?.textAlignment = .center
        pickButton.layer.borderColor = mainColor.cgColor
        pickButton.layer.shadowColor = mainColor.cgColor
        pickButton.layer.shadowOpacity = 0.8
        
        pickButton.addTarget(self, action: #selector(checkAge), for: .touchUpInside)
        addSubview(pickButton)
        
        // none
        if firstLoad {
            pickButton.setTitle("brain age: ?", for: .normal)
            hintImage.contentMode = .scaleAspectFit
            addSubview(hintImage)
            
            var move = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { (timer) in
                self.hintImage.transform = move ? CGAffineTransform(translationX: fontFactor * 4, y: 0) : CGAffineTransform.identity
                move = !move
            })
        }
        
        setupFrames()
    }
    
    override var frame: CGRect {
        didSet{
            if frame != oldValue {
                setupFrames()
            }
        }
    }
    
    fileprivate var originCenters = [CGPoint]()
    fileprivate func setupFrames() {
        let oneW = bounds.width / 345
        titleLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 0.3).insetBy(dx: 10 * oneW, dy: 0)
        titleLabel.font = UIFont.systemFont(ofSize: 12 * oneW, weight: .semibold)
        
        let imageLength = 75 * oneW
        let cGap = 20 * oneW + imageLength
        let imageCY = titleLabel.frame.maxY + imageLength * 0.5
        originCenters = [CGPoint(x: bounds.midX - cGap, y: imageCY), CGPoint(x: bounds.midX, y: imageCY), CGPoint(x: bounds.midX + cGap, y: imageCY)]
        for (i, image) in brainImages.enumerated() {
            image.frame = CGRect(center: originCenters[i], length: imageLength)
            labels[i].frame = CGRect(x: 0, y: image.bounds.maxY, width: imageLength, height: imageLength * 0.4)
            labels[i].font = UIFont.systemFont(ofSize: 12 * oneW, weight: .semibold)
        }
        
        pickButton.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height * 0.83), width: 182 * oneW, height: 35 * oneW)
        pickButton.titleLabel?.font = UIFont.systemFont(ofSize: 14 * oneW, weight: .semibold)
        pickButton.layer.cornerRadius = 17.5 * oneW
        pickButton.layer.borderWidth = 2 * oneW
        pickButton.layer.shadowOffset = CGSize(width: 0, height: 4 * oneW)
        pickButton.layer.shadowRadius = 6 * oneW
        
        hintImage.frame = CGRect(x: 20 * oneW, y: pickButton.frame.minY, width: 55 * oneW, height: 35 * oneW)
    }

    @objc func checkAge() {
        firstLoad = false
        if timer != nil {
            timer.invalidate()
            timer = nil
            hintImage.isHidden = true
        }
        
        let picker = Bundle.main.loadNibNamed("DatePickerViewController", owner: self, options: nil)?.first as! DatePickerViewController
        picker.getBrainAge = self
        picker.userKey = userKey
        let record = CalendarCenter.getDateFromString(userCenter.getDobStringOfUser(userKey)) ?? Date()
        picker.recordYear = CalendarCenter.getYearOfDate(record)
        viewController.presentOverCurrentViewController(picker, completion: nil)
    }

    func ageIsChanged() {
        titleLabel.text = "Your brain age"
        let ageString = NSMutableAttributedString(string: "\(displayAge!)", attributes: [ .font: UIFont.systemFont(ofSize: pickButton.frame.height * 22 / 35, weight: .bold)])
        ageString.append(NSAttributedString(string: " years old", attributes: [ .font: UIFont.systemFont(ofSize: pickButton.frame.height * 14 / 35, weight: .bold)]))
        pickButton.setAttributedTitle(ageString, for: .normal)
        
        var centerIndex = 1 // equal
        if refValue < 0 {   // younger
            centerIndex = 0
            mainColor = UIColorFromRGB(216, green: 253, blue: 179)
        }else if refValue > 0 {
            centerIndex = 2
            mainColor = UIColorFromRGB(255, green: 167, blue: 178)
        }else {
            mainColor = UIColorFromRGB(255, green: 245, blue: 118)
        }
        var other = [UIImageView]()
        for (i, image) in brainImages.enumerated() {
            if i != centerIndex {
                other.append(image)
                labels[i].isHidden = true
            }else {
                labels[i].isHidden = false
            }
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.brainImages[centerIndex].center = self.originCenters[1]
            self.brainImages[centerIndex].transform = CGAffineTransform.identity
            
            other[0].center = self.originCenters[0]
            other[1].center = self.originCenters[2]
            
            for image in other {
                image.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
        }) { (true) in
            self.setNeedsDisplay()
            self.reference.showSuggestion()
        }
    }
    
    override func draw(_ rect: CGRect) {
        // prepare
        if !firstLoad && originCenters.count == 3 {
            let dash = UIBezierPath()
            let topControl = CGPoint(x: bounds.midX, y: bounds.height * 0.2)
            let bottomControl = CGPoint(x: bounds.midX, y: 2 * originCenters[0].y - bounds.height * 0.2)
            
            dash.move(to: originCenters[0])
            dash.addLine(to: originCenters[2])
            dash.addCurve(to: originCenters[0], controlPoint1: topControl, controlPoint2: topControl)
            dash.addCurve(to: originCenters[2], controlPoint1: bottomControl, controlPoint2: bottomControl)
            
            let one = bounds.width / 345
            dash.setLineDash([2 * one, 2 * one], count: 1, phase: 1)
            
            UIColorGray(192).setStroke()
            dash.stroke()
            
            let pointer = UIBezierPath()
            let pHeight = 9 * one
            pointer.move(to: CGPoint(x: bounds.midX, y: pickButton.frame.minY - pHeight))
            pointer.addLine(to: CGPoint(x: bounds.midX - pHeight, y: pickButton.frame.minY))
            pointer.addLine(to: CGPoint(x: bounds.midX + pHeight, y: pickButton.frame.minY))
            pointer.close()
            mainColor.setFill()
            pointer.fill()
        }
    }
}
