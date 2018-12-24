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
//    fileprivate let shieldTable = StretchExplainTableView(frame: CGRect.zero, style: .plain)
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
//        shieldTable.hostScroll = self
        suffixLabel.numberOfLines = 0
    
        addSubview(getBrainAge)
        addSubview(refTextView)
//        addSubview(shieldTable)
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
            
            // show?
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
        
        let textAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12 * factor, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor: UIColorGray(74)]
        if let classifier = MatchedCardsDisplayModel.getResultClassifierOfMeasurement(measurement) {
            // suggestion

            var resultString = ""
            for result in classifier.results {
                resultString.append(result)
                resultString.append("\n")
            }
            
            let topString = NSMutableAttributedString(string: resultString, attributes: textAttributes)
            topString.append(NSAttributedString(string: "\nSuggestion\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16 * factor, weight: UIFont.Weight.bold), NSAttributedStringKey.foregroundColor: UIColorFromRGB(80, green: 211, blue: 135)]))
            
            var suggestion = ""
            if classifier.suggestions.count != 0 {
                for s in classifier.suggestions {
                    suggestion.append(s)
                    suggestion.append("\n")
                }
            }
            topString.append(NSAttributedString(string: suggestion, attributes: textAttributes))
            
            // SHIELD
//            let shieldTitle = "\nTo help you improve your Healthy Brain Score and your Brain Age, Dr Rudy Tanzi (MGH, Mass General Hospital) proposed “SHIELD” for the brain:\n"
//            let shield = NSMutableAttributedString(string: shieldTitle, attributes: textAttributes)
//            shield.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14 * factor, weight: UIFont.Weight.bold)], range: NSMakeRange(shieldTitle.count - 23, 6))
//            topString.append(shield)
            
            refTextView.attributedText = topString
        }
            
        // frame of textView
        let xMargin = 15 * factor
        
        // suggestion
        refTextView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 1000).insetBy(dx: xMargin, dy: 0)
        let textH = refTextView.layoutManager.usedRect(for: refTextView.textContainer).height
        refTextView.frame = CGRect(x: 0, y: getBrainAge.frame.maxY, width: bounds.width, height: textH + xMargin * 0.5)
        refTextView.textContainerInset = UIEdgeInsets(top: xMargin * 0.2, left: xMargin, bottom: 0, right: xMargin)
        
//        let shield = ["Sleep - 8 hours", "Handle – Manage Stres", "Interact -Socialize", "Exercise -8000 steps", "Learn -New Things", "Diet -Mediterranean/Veg"]
//        let detail = ["You should strive for eight hours of shuteye per night. If you can’t get it done continuously, take naps.", "Don’t let stress overwhelm you.", "Stay social. Loneliness is a stress factor.", "It removes inflammation and plaque from the brain. Working out also causes new nerve cells to be born in the hippocampus—the battle zone for Alzheimer’s.", "The more synapses you make, the more you can lose before you lose it.", "The Mediterranean Diet, which is high in fruits, vegetables, olive oil, and whole grains and involves eating proteins occasionally, is best for your brain-  your diet, and its effect on your microbiome, matters a lot as it has a profound effect on neuroinflammation."]
//
//        shieldTable.setupWithFrame(CGRect(x: 0, y: refTextView.frame.maxY, width: bounds.width, height: 335 * factor).insetBy(dx: xMargin, dy: 0), titles: shield, texts: detail)
//        shieldTable.layer.cornerRadius = 8 * factor
//
//        let moreInfo = "Dr Rudy Tanzi stressed that these are “things you can do now,” and importantly, “These are choices you make that determine where you’ll be in the future.”"
//        let suffix = NSMutableAttributedString(string: moreInfo, attributes: textAttributes)
//        let pCount = "Dr Rudy Tanzi stressed that these are ".count
//        suffix.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14 * factor, weight: UIFont.Weight.bold)], range: NSMakeRange(pCount - 1, "“things you can do now,”".count))
//
//        let count2 = "“These are choices you make that determine where you’ll be in the future.”".count
//        suffix.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14 * factor, weight: UIFont.Weight.bold)], range: NSMakeRange(moreInfo.count - count2 - 1, count2))
//        suffixLabel.attributedText = suffix
//
//        adjustFrame()
    }
//
//    func adjustFrame() {
//        let xMargin = shieldTable.frame.minX
//        suffixLabel.frame = CGRect(x: xMargin, y: shieldTable.frame.maxY + xMargin * 0.5, width: shieldTable.frame.width, height: 1000)
//        suffixLabel.adjustWithWidthKept()
//        self.contentSize = CGSize(width: frame.width, height: suffixLabel.frame.maxY + xMargin * 0.5)
//
//        refDelegate.maskLayer.isHidden = contentSize.height <= bounds.height
//    }
}
