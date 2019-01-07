//
//  ScorecardDetailView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/23.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ScorecardDetailView: UIScrollView {
    // scorecardKey
    enum DetailStyle {
        case none
        case age
        case vitaminD
    }
    weak var scorecardDelegate: ScorecardView!
    
    fileprivate let titleTextView = UITextView()
    fileprivate let cardsView = AnsweredCardsCollectionView.createWithFrame(CGRect.zero)
    fileprivate var ageReferenceView: AgeReferenceView!
    fileprivate var vitaminDView: VitaminDRefrenceView!
    fileprivate var getVitaminD: VitaminDGetView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateUI() {
        backgroundColor = UIColor.white
        
        titleTextView.text = "You can find out how each of your card selection choice impact the overall score calculation"
        
        titleTextView.isEditable = false
        titleTextView.isSelectable = false
        titleTextView.isScrollEnabled = false
        addSubview(titleTextView)
        
        addSubview(cardsView)
    }
    
    fileprivate var riskKey: String!
    fileprivate var style: DetailStyle = .none
    func setupWithRiskKey(_ riskKey: String, userKey: String) {
//        for view in self.subviews {
//            if view != cardsView && view != titleTextView {
//                view.removeFromSuperview()
//            }
//        }
//        
//
//        if riskKey == brainAgeKey {
//            style = .age
//            // age
//            ageReferenceView = AgeReferenceView()
//
//            ageReferenceView.setupWithRiskKey(riskKey, userKey: userKey, factor: factor)
//            addSubview(ageReferenceView)
//        }else if riskKey == vitaminDInKey || riskKey == "d876734a-9d27-11e6-80f5-76304dec7eb7" {
//            // TODO: ira
//            style = .vitaminD
//            vitaminDView = VitaminDRefrenceView()
//            vitaminDView.detailDelegate = self
//            vitaminDView.setupWithRiskKey(riskKey, userKey: userKey, factor: factor)
//
//            addSubview(vitaminDView)
//
//            getVitaminD = VitaminDGetView()
//            scorecardDelegate.addSubview(getVitaminD)
//        }else {
//            style = .none
//        }
//
        cardsView.riskKey = riskKey
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleTextView.font = UIFont.systemFont(ofSize: 12 * bounds.width / 345, weight: UIFontWeightMedium)
        
        let xMargin = bounds.width * 0.05

        titleTextView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width * 0.14).insetBy(dx: xMargin * 0.5, dy: 0)
        
        cardsView.frame = CGRect(x: 0, y: titleTextView.frame.maxY, width: bounds.width, height: bounds.height - titleTextView.frame.height).insetBy(dx: xMargin * 0.5, dy: 0)
        var maxY: CGFloat = cardsView.frame.maxY
        // topViews
        
        if style != .none {
            cardsView.frame = CGRect(x: 0, y: titleTextView.frame.maxY, width: bounds.width, height: cardsView.contentSize.height)
            maxY = cardsView.frame.maxY
        }
        
        if style == .age {
            // explain part
            ageReferenceView.layoutWithFrame(CGRect(x: 0, y: maxY + xMargin, width: bounds.width, height: bounds.height))
            maxY = ageReferenceView.frame.maxY
        }else if style == .vitaminD {
            vitaminDView.layoutWithFrame(CGRect(x: 0, y: maxY + xMargin, width: bounds.width, height: bounds.height))
            let mHeght = scorecardDelegate.bounds.height - scorecardDelegate.topBackView.frame.height
            getVitaminD.setupContentWithFrame(CGRect(x: 0, y: frame.maxY, width: bounds.width, height: mHeght))
            maxY = vitaminDView.frame.maxY
        }
        
        contentSize = CGSize(width: bounds.width, height: maxY)
    }
    
    func showMethod() {
        let mH = getVitaminD.frame.height
        UIView.animate(withDuration: 0.4) {
            self.getVitaminD.transform = CGAffineTransform(translationX: 0, y: -mH)

        }
    }
}
