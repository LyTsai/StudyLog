//
//  ScorecardConcertoView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/25.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

enum ConcertoType: String {
    case what = "what"
    case why = "why"
    case how = "how"
    case insight = "insight"
    case fyi = "fyi"
    
    var topColor: UIColor {
        switch self {
        case .what: return UIColorFromRGB(199, green: 252, blue: 184)
        case .why: return UIColorFromRGB(99, green: 239, blue: 255)
        case .how: return UIColorFromRGB(255, green: 226, blue: 172)
        case .insight: return UIColorFromRGB(255, green: 151, blue: 164)
        case .fyi: return UIColorFromRGB(255, green: 151, blue: 164)
        }
    }

    var bannerColor: UIColor {
        switch self {
        case .what: return UIColorFromRGB(236, green: 101, blue: 71)
        case .why: return UIColorFromRGB(169, green: 78, blue: 216)
        case .how: return UIColorFromRGB(142, green:229, blue: 235)
        case .insight: return UIColorFromRGB(0, green: 102, blue: 235)
        case .fyi: return UIColorFromRGB(0, green: 102, blue: 235)
        }
    }
    
    var decoImage: UIImage! {
        return UIImage(named: "balloon_\(rawValue)")
    }
}


class ScorecardConcertoView: UIView {
    var concertoType = ConcertoType.what
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tintView: UIView!
    @IBOutlet weak var topDecoLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var subTitleDecoLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var balloonView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addView()
    }
    
    var view: UIView!
    var remainedFrame: CGRect {
        let top = balloonView.frame.maxY
        let bottom = view.bounds.height * 0.01
        return CGRect(x: 0, y: top, width: view.bounds.width, height: view.bounds.height - top - bottom)
    }
    
    var blankFrame: CGRect {
        let top = topView.frame.maxY
        let bottom = view.bounds.height * 0.01
        return CGRect(x: 0, y: top, width: view.bounds.width, height: view.bounds.height - top - bottom)
    }
    
    fileprivate let bannerMask = CAShapeLayer()
    func addView() {
        backgroundColor = UIColor.clear
        view = Bundle.main.loadNibNamed("ScorecardConcertoView", owner: self, options: nil)?.first as! UIView
        view.layer.masksToBounds = true
        bannerView.layer.mask = bannerMask
        bannerMask.fillColor = UIColor.red.cgColor
        bannerMask.backgroundColor = UIColor.clear.cgColor
        
        addSubview(view)
    }
    
    // 345 * 586
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let ratio = min(bounds.width / 345, bounds.height / 586)
//        view.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY), width: ratio * 345, height: ratio * 586)
        view.frame = bounds
        view.layoutSubviews()
        view.layer.cornerRadius = 8 * ratio
        
        setupFonts()
    }
    
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        // mask
        let maskPath = UIBezierPath()
        maskPath.move(to: CGPoint.zero)
        maskPath.addLine(to: CGPoint(x: 0, y: bannerView.bounds.height))
        maskPath.addLine(to: CGPoint(x: bannerView.bounds.width, y: bannerView.bounds.height))
        maskPath.addLine(to: CGPoint(x: subTitleLabel.frame.maxX, y: bannerView.bounds.midY))
        maskPath.addLine(to: CGPoint(x: bannerView.bounds.width, y: 0))
        
        maskPath.close()
        bannerMask.path = maskPath.cgPath
    }
    
    fileprivate func setupFonts() {
        let ratio = min(bounds.width / 345, bounds.height / 586)
        let decoAttribute = [NSAttributedStringKey.strokeColor: UIColor.black, NSAttributedStringKey.strokeWidth: NSNumber(value: -15)]
        
        // title
        let topString = "\(metricName)\n- \(riskTypeFullName)"
        let basicString = NSMutableAttributedString(string: topString, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16 * ratio, weight: UIFont.Weight.bold)])
        basicString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: ratio * 14, weight: UIFont.Weight.medium)], range: NSMakeRange(metricName.count + 1, riskTypeFullName.count + 2))
        topLabel.attributedText = basicString
        topLabel.textColor = topTintColor
        
        basicString.addAttributes(decoAttribute, range: NSMakeRange(0, topString.count))
        topDecoLabel.attributedText = basicString
        
        // sub
        let subString = NSMutableAttributedString(string: "Scorecard Concerto:\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: ratio * 14, weight: UIFont.Weight.semibold)])
        subString.append(NSAttributedString(string: subTitle, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: ratio * 10, weight: UIFont.Weight.regular)]))
        subTitleLabel.attributedText = subString
    
        subString.addAttributes(decoAttribute, range: NSMakeRange(0, "Scorecard Concerto:\n\(subTitle)".count))
        subTitleDecoLabel.attributedText = subString
    }
    
    // setup
    fileprivate var metricName = ""
    fileprivate var riskTypeFullName = ""
    fileprivate var subTitle = ""
    
    fileprivate var topTintColor: UIColor!
    func setupWithRisk(_ riskKey: String, subTitle: String, topTintColor: UIColor, decoImage: UIImage!, bannerColor: UIColor) {
        self.topTintColor = topTintColor
        self.subTitle = subTitle
        
        topView.backgroundColor = topTintColor
        tintView.backgroundColor = topTintColor.withAlphaComponent(0.6)
        balloonView.image = decoImage
        bannerView.backgroundColor = bannerColor
        
        if let risk = collection.getRisk(riskKey) {
            metricName = risk.metric!.name!
            riskTypeFullName = collection.getFullNameOfRiskType(risk.riskTypeKey!)
        }
        
        balloonView.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi / 18))
        setupFonts()
    }
    
    
    func setupWithRisk(_ riskKey: String, subTitle: String, concertoType: ConcertoType) {
        self.concertoType = concertoType
        setupWithRisk(riskKey, subTitle: subTitle, topTintColor: concertoType.topColor, decoImage: concertoType.decoImage, bannerColor: concertoType.bannerColor)
    }
}
