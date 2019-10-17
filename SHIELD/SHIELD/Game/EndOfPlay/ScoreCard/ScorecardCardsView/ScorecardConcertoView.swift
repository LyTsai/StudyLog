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

    var bannerColor: UIColor {
        switch self {
        case .what: return UIColorFromHex(0xFFC3B7)
        case .why: return UIColorFromHex(0xA8B5CF)
        case .how: return UIColorFromHex(0x7DD9BE)
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
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var calendarBack: UIImageView!
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var balloonView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
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
        return mainView.frame
    }
    
    fileprivate let bannerMask = CAShapeLayer()
    func addView() {
        self.backgroundColor = UIColor.clear
        view = Bundle.main.loadNibNamed("ScorecardConcertoView", owner: self, options: nil)?.first as? UIView
        view.layer.masksToBounds = true
        bannerView.layer.mask = bannerMask
        bannerMask.fillColor = UIColor.red.cgColor
        bannerMask.backgroundColor = UIColor.clear.cgColor
        balloonView.layer.addBlackShadow(4 * fontFactor)
        calendarBack.layer.addBlackShadow(2)
        
        addSubview(view)
    }
    
    // 345 * 586
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let ratio = min(bounds.width / 365, bounds.height / 537)
        view.frame = bounds
        view.layoutSubviews()
        bannerView.layoutSubviews()
        
        // mask
        let maskPath = UIBezierPath()
        maskPath.move(to: CGPoint.zero)
        maskPath.addLine(to: CGPoint(x: 0, y: bannerView.bounds.height))
        maskPath.addLine(to: CGPoint(x: bannerView.bounds.width, y: bannerView.bounds.height))
        maskPath.addLine(to: CGPoint(x: max(topLabel.frame.maxX, bannerView.bounds.width - bannerView.bounds.height * 0.5), y: bannerView.bounds.midY))
        maskPath.addLine(to: CGPoint(x: bannerView.bounds.width, y: 0))
        
        maskPath.close()
        bannerMask.path = maskPath.cgPath
        
        // cornerRadius
        view.layer.cornerRadius = 8 * ratio
        mainView.layer.cornerRadius = 8 * ratio
    
        setupFonts()
    }
    
    var title = "Scorecard Concerto:\n" {
        didSet{
            if title != oldValue {
                setupFonts()
            }
        }
    }
    func setupFonts() {
        let ratio = min(bounds.width / 365, bounds.height / 537)
        // sub
        let subString = NSMutableAttributedString(string: title, attributes: [ .font: UIFont.systemFont(ofSize: ratio * 14, weight: .semibold)])
        subString.append(NSAttributedString(string: subTitle, attributes: [ .font: UIFont.systemFont(ofSize: ratio * 11, weight: .regular)]))
        topLabel.attributedText = subString
        
        monthLabel.font = UIFont.systemFont(ofSize: 10 * ratio, weight: .medium)
        dayLabel.font = UIFont.systemFont(ofSize: 12 * ratio, weight: .medium)
    }
    
    // setup
    fileprivate var subTitle = ""
    func setupWithSubTitle(_ subTitle: String, concertoType: ConcertoType) {
        self.concertoType = concertoType
        self.subTitle = subTitle
        
        view.backgroundColor = UIColorFromHex(0xE1F2CF)
        balloonView.image = concertoType.decoImage
        bannerView.backgroundColor = concertoType.bannerColor
        
        balloonView.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi / 18))
        setupFonts()
    }
    
    func setupWithMeasurement(_ measurement: MeasurementObjModel)  {
        if let realDate = ISO8601DateFormatter().date(from: measurement.timeString) {
            let day = CalendarCenter.getDayOfDate(realDate)
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMM"
            let month = monthFormatter.string(from: realDate)
            
            dayLabel.text = "\(day)"
            monthLabel.text = month
        }
    }
    func hideCalendar() {
        dayLabel.text = ""
        monthLabel.text = ""
        calendarBack.isHidden = true
    }
}
