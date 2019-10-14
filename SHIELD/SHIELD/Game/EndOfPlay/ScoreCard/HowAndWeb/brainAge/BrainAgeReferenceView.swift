//
//  BrainAgeReferenceView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/2.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class BrainAgeReferenceView: UIScrollView {
    fileprivate let refTextView = UITextView()
    fileprivate let getBrainAge = GetBrainAgeView()
    fileprivate let suffixLabel = UILabel()
    
    weak var refDelegate: ScoreReferenceView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func updateUI() {
        bounces = false
        
        refTextView.isEditable = false
        refTextView.isScrollEnabled = false
        refTextView.isSelectable = false
        
        getBrainAge.reference = self
        suffixLabel.numberOfLines = 0
    
        addSubview(getBrainAge)
        addSubview(refTextView)
        addSubview(suffixLabel)
        
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            viewController.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    fileprivate var measurement: MeasurementObjModel!
    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        self.measurement = measurement
        
        refTextView.text = ""
        if let classifier = MatchedCardsDisplayModel.getResultClassifierOfMeasurement(measurement) {
            // age
            let refValue = Int(classifier.referenceValue ?? 0)
            getBrainAge.userKey = measurement.playerKey
            getBrainAge.refValue = refValue
        }
    }
    
    func layoutWithFrame(_ frame: CGRect) {
        self.frame = frame
        
        // age
        getBrainAge.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width / 345 * 225)
    }

    fileprivate var suggestion = false
    fileprivate var showAll = false
    func showSuggestion() {
        let factor = bounds.width / 345
        suggestion = true
        
        let textAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12 * factor, weight: .medium), .foregroundColor: UIColorGray(74)]
        if let classifier = MatchedCardsDisplayModel.getResultClassifierOfMeasurement(measurement) {
            // suggestion

            var resultString = ""
            for result in classifier.results {
                resultString.append(result)
                resultString.append("\n")
            }
            
            let topString = NSMutableAttributedString(string: resultString, attributes: textAttributes)
            topString.append(NSAttributedString(string: "\nSuggestion\n", attributes: [ .font: UIFont.systemFont(ofSize: 16 * factor, weight: .bold), .foregroundColor: UIColorFromRGB(80, green: 211, blue: 135)]))
            
            var suggestion = ""
            if classifier.suggestions.count != 0 {
                for s in classifier.suggestions {
                    suggestion.append(s)
                    suggestion.append("\n")
                }
            }
            topString.append(NSAttributedString(string: suggestion, attributes: textAttributes))
            
            refTextView.attributedText = topString
        }
            
        // frame of textView
        let xMargin = 15 * factor
        
        // suggestion
        refTextView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 1000).insetBy(dx: xMargin, dy: 0)
        let textH = refTextView.layoutManager.usedRect(for: refTextView.textContainer).height
        refTextView.frame = CGRect(x: 0, y: getBrainAge.frame.maxY, width: bounds.width, height: textH + xMargin * 0.5)
        refTextView.textContainerInset = UIEdgeInsets(top: xMargin * 0.2, left: xMargin, bottom: 0, right: xMargin)
        contentSize = CGSize(width: bounds.width, height: refTextView.frame.maxY)
    }
}
