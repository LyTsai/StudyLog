//
//  ScorecardHowAssessmentViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/26.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardHowAssessmentViewController: UIViewController {
    var measurement: MeasurementObjModel!   // the matched cards (iRa, iPa, iCa) for assessment
    fileprivate var backView: ScorecardConcertoView!
    fileprivate var cardsView: CardsResultDisplayTableView!
    fileprivate let legendLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // go back dismiss
        let marginX = 8 * fontFactor
        let buttonH = 30 * fontFactor
        let dismiss = UIButton(type: .custom)
//        dismiss.setBackgroundImage(#imageLiteral(resourceName: "present_goBack"), for: .normal)
        dismiss.setBackgroundImage(UIImage(named: "dismiss_white"), for: .normal)
        dismiss.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismiss.frame = CGRect(x: width - marginX - 30 * fontFactor, y: topLength - 30 - marginX, width: buttonH, height: buttonH)
        view.addSubview(dismiss)
        
        // matched card score improving
        let backFrame = CGRect(x: 0, y: dismiss.frame.maxY, width: width, height: height - dismiss.frame.maxY - bottomLength + 49).insetBy(dx: marginX, dy: marginX)
        backView = ScorecardConcertoView(frame: backFrame)
        backView.hideCalendar()
        
        backView.title = "Improve your score –\n"
        backView.setupWithSubTitle("Cards to Change; Cards to Keep; and Cards to Watch", concertoType: .how)
        
        view.addSubview(backView)
        backView.layoutSubviews()
        
        // legend
        let remainedFrame = backView.remainedFrame
        let textSize = 12 * fontFactor
        let tag = #imageLiteral(resourceName: "icon_legend")
        let imageText = NSTextAttachment()
        imageText.image = tag
        imageText.bounds = CGRect(x: 0, y: 0, width: textSize * 17 / 16, height: textSize)
        
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(attachment:imageText))
        attributedText.append(NSAttributedString(string: "- Your match", attributes: [.font: UIFont.systemFont(ofSize: textSize, weight: .semibold)]))
        legendLabel.attributedText = attributedText
        legendLabel.frame = CGRect(x: remainedFrame.minX, y: remainedFrame.minY, width: remainedFrame.width, height: 36 * fontFactor).insetBy(dx: 18 * fontFactor, dy: 0)
        
        backView.addSubview(legendLabel)
        
        // cards
        let cardsFrame = CGRect(x: remainedFrame.minX, y: legendLabel.frame.maxY, width: remainedFrame.width, height: remainedFrame.height - legendLabel.frame.height)
        cardsView = CardsResultDisplayTableView.createWithFrame(cardsFrame, cellHeight: 65 * fontFactor, headerHeight: 80 * fontFactor, footerHeight: 20 * fontFactor)
        cardsView.setupWithMeasurement(measurement)
        backView.addSubview(cardsView)
    }

    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}
