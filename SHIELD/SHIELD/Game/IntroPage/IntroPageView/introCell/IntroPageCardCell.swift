//
//  IntroPageCardCell.swift
//  AnnielyticX
//
//  Created by iMac on 2018/3/21.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
let introPageCardCellID = "intro page card cell identifier"
class IntroPageCardCell: UICollectionViewCell {
//    var isCurrent = false {
//        didSet{
//            titleGradientLayer.locations = isCurrent ? [0.05, 0.95]: [0, 0.01]
//            titleLabel.textAlignment = isCurrent ? .left : .right
//        }
//    }
    
    var itemGap: Int = 0 {
        didSet{
            titleGradientLayer.locations = (itemGap == 0) ? [0.05, 0.95]: [0, 0.01]
            titleLabel.textAlignment = (itemGap <= 0) ? .left : .right
        }
    }

    // top
    fileprivate let maskLayer = CAShapeLayer()
    fileprivate let titleLabel = UILabel()
    fileprivate let titleGradientLayer = CAGradientLayer()
    
    fileprivate var riskPlayView: IntroPageRiskPlayView!
    fileprivate var playStateView: IntroPageStateView!
    fileprivate let backView = UIView()
    fileprivate let infoView = IntroInfoDisplayView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    fileprivate func loadView() {
        contentView.backgroundColor = UIColor.clear
        backView.backgroundColor = UIColorFromHex(0xF8FFF4)
        contentView.addSubview(backView)
        
        // top
        titleGradientLayer.startPoint = CGPoint.zero
        titleGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        titleGradientLayer.colors = [UIColorFromHex(0xB4EC51).cgColor, UIColorFromHex(0x57A32A).cgColor]
        titleGradientLayer.locations = [0.05, 0.95]
        maskLayer.fillColor = UIColor.red.cgColor
        maskLayer.lineWidth = 0
        titleGradientLayer.mask = maskLayer
        
        titleLabel.numberOfLines = 0

        // play
        riskPlayView = Bundle.main.loadNibNamed("IntroPageRiskPlayView", owner: self, options: nil)?.first as? IntroPageRiskPlayView
        riskPlayView.layer.addBlackShadow(2 * fontFactor)
        
        // info
        
        // state
        playStateView = Bundle.main.loadNibNamed("IntroPageStateView", owner: self, options: nil)?.first as? IntroPageStateView
        
        // add
        contentView.addSubview(playStateView)
        contentView.addSubview(infoView)
        contentView.addSubview(riskPlayView)
        contentView.layer.addSublayer(titleGradientLayer)
        contentView.addSubview(titleLabel)

        layer.addBlackShadow(8 * fontFactor)
    }
    
    fileprivate var topFrame = CGRect.zero
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = 6 * fontFactor
        backView.layer.cornerRadius = radius
        if noRisk {
            // only intro
            backView.frame = bounds
            topFrame = CGRect(x: 0, y: 0, width: bounds.width * headerRatio, height: 25 * fontFactor)
        }else {
            topFrame = CGRect(x: startPoint * bounds.width, y: 0, width: bounds.width * headerRatio, height: 55 * fontFactor)
        }
        
        // top label
        titleGradientLayer.frame = topFrame
        titleLabel.frame = topFrame.insetBy(dx: 6 * fontFactor, dy: 0)
        let maskPath = UIBezierPath(roundedRect: titleGradientLayer.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
        maskLayer.path = maskPath.cgPath
        
        // risk
        let bottomMarginX = 20 * fontFactor
        if !noRisk {
            riskPlayView.frame = CGRect(x: 0, y: topFrame.maxY, width: bounds.width, height: 260 * fontFactor)
            backView.frame = CGRect(x: 0, y: riskPlayView.center.y, width: bounds.width, height: bounds.height - riskPlayView.center.y)

            infoView.layer.cornerRadius = radius
            infoView.layer.addBlackShadow(radius * 0.5)
            
            let infoH = bounds.height - riskPlayView.frame.maxY - 16 * fontFactor
            let notPlayed = !playStateView.notPlayView.isHidden
            infoView.frame = CGRect(x: 0, y: riskPlayView.frame.maxY + ( notPlayed ? 8 * fontFactor : 41 * fontFactor - infoH), width: bounds.width, height: infoH).insetBy(dx: bottomMarginX, dy: 0)
            
            let stateY = riskPlayView.frame.maxY + fontFactor * 48
            playStateView.frame = CGRect(x: 0, y: stateY, width: bounds.width, height: bounds.height - stateY - radius).insetBy(dx: bottomMarginX, dy: 0)
        }else {
            infoView.frame = CGRect(x: 0, y: topFrame.maxY, width: bounds.width, height: bounds.height - topFrame.maxY).insetBy(dx: bottomMarginX, dy: radius)
        }
    }
    
    fileprivate var headerRatio: CGFloat = 1
    fileprivate var startPoint: CGFloat = 0
    fileprivate var noRisk = false {
        didSet{
            if noRisk != oldValue {
                titleLabel.textAlignment = noRisk ? .center : .left
                riskPlayView.isHidden = noRisk
                playStateView.isHidden = noRisk
                infoView.strench = noRisk
                
                setNeedsLayout()
            }
        }
    }
    func configureWithRisk(_ risk: RiskObjModel!, metric: MetricObjModel, headerRatio: CGFloat, startPoint: CGFloat) {

        let titleFont = UIFont.systemFont(ofSize: 12 * fontFactor, weight: .semibold)
        titleLabel.font = titleFont
        infoView.loadInfoWithMetric(metric)
        
        if risk == nil {
            noRisk = true
            titleLabel.text = ""
            return
        }
        
        // attach with given user's matches.  whatif data only valid for current session
        if userCenter.userState == .login {
            selectionResults.useLastMeasurementForUser(userCenter.currentGameTargetUser.Key(), riskKey: risk.key, whatIf: false)
        }
        
        noRisk = false
        self.headerRatio = headerRatio
        self.startPoint = startPoint
        
        let riskIntro = risk.intro ?? ""

        if riskIntro != "" {
            let attributedS = NSMutableAttributedString(string: "\(risk.name!):\n", attributes: [.font: titleFont])
            attributedS.append(NSAttributedString(string: riskIntro, attributes: [.font: UIFont.systemFont(ofSize: 11 * fontFactor)]))
            titleLabel.attributedText = attributedS
        } else {
            titleLabel.text = risk.name
        }
        
        riskPlayView.fillDataWithRisk(risk)
        playStateView.setupWithRisk(risk)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if point.y <= topFrame.maxY && !topFrame.contains(point) {
            return nil
        }

        return view
    }
}
