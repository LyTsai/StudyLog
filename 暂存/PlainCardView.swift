//
//  File.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/29.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import SDWebImage

// only texts and image, used on many cards
// MARK: -------- all labels are changed to textView now, with only name remained
class PlainCardView: CardBackView {
    // MARK: --------- properties -------------------
    override var mainColor: UIColor {
        didSet {
            cardTitleBackView.mainColor = mainColor
            stamp.mainColor = mainColor
        }
    }
    
    // open, fill data
    var title: String! {
        didSet{ titleTextView.text = title}
    }

//    var prompt: String! {
//        didSet{
//            promptTextView.text = prompt
//        }
//    }
    
    var detail: String! {
        didSet{ detailTextView.text = detail }
    }
    
    var mainImageUrl: URL! {
        didSet{
            mainImageView.sd_setShowActivityIndicatorView(true)
            mainImageView.sd_setIndicatorStyle(.gray)
            mainImageView.sd_setImage(with: mainImageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached, progress: nil) { (image, error, type, url) in
            }
        }
    }
    
    var tagUrl: URL! {
        didSet{
            promptTag.sd_setShowActivityIndicatorView(true)
            promptTag.sd_setIndicatorStyle(.gray)
            promptTag.sd_setImage(with: tagUrl, placeholderImage: nil, options: .refreshCached, progress: nil) { (image, error, type, url) in
            }
        }
    }
    
    // hint
    let stamp = StampView()
    
    // size concerned, change with the backImage
    fileprivate var standardW: CGFloat {
        return bounds.width / 335
    }
    fileprivate var standardH: CGFloat {
        return bounds.height / 446
    }
    
    var bottomForMore: CGFloat {
        return 55 * standardH
    }
    
    // in case there is more change about the textLabel or imageView
    let titleTextView = AutoScrollTextView()
    let cardTitleBackView = CardTitleView()
//    let promptTextView = AutoScrollTextView() //        UILabel()
    let detailTextView = AutoScrollTextView() //        UILabel()
    let mainImageView = UIImageView()
    let promptTag = UIImageView()
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    // add views
    fileprivate let sideBack = UIImageView()
    fileprivate func updateUI() {
        // setup side
        sideBack.image = ProjectImages.sharedImage.cardSide
        
        // setup imageView
        mainImageView.contentMode = .scaleAspectFit
        promptTag.contentMode = .scaleAspectFit
        promptTag.layer.addBlackShadow(2 * fontFactor)
        
        // add
        addSubview(mainImageView)
        addSubview(promptTag)
        addSubview(cardTitleBackView)
        cardTitleBackView.addSubview(titleTextView)
        addSubview(detailTextView)
        addSubview(sideBack)
        addSubview(stamp)
        
        // tap
        hintImageView.contentMode = .scaleAspectFit
        hintImageView.image = UIImage(named: "textScrollHint")
        hintImageView.isUserInteractionEnabled = true
        addSubview(hintImageView)
        addSubview(stamp)
        
        let upSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(showOrHideText))
        upSwipeGR.direction = .up
        let downSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(showOrHideText))
        downSwipeGR.direction = .down
        self.addGestureRecognizer(upSwipeGR)
        self.addGestureRecognizer(downSwipeGR)
    }
    
    // for prompt
//    var prompted: Bool {
//        return withPrompt
//    }
    
//    fileprivate var withPrompt = false
//    func addSetForPrompt() {
//        withPrompt = true
//
//        // prompt label
////        if promptTextView.superview == nil {
////            addSubview(promptTextView)
////        }
//        if promptTag.superview == nil {
//            addSubview(promptTag)
//        }
//    }
    
//    func removePrompt() {
//        promptTag.removeFromSuperview()
////        promptTextView.removeFromSuperview()
//        withPrompt = false
//    }
    
    fileprivate let hintImageView = UIImageView()

    func hideSide(_ hide: Bool) {
        sideBack.isHidden = hide
    }
    
    // layout subviews
    // call when the layout is changed, except from the frame of view is changed
    fileprivate var textScrolling = true
//    fileprivate var recordPromptFrame = CGRect.zero
    fileprivate var recordDetailFrame = CGRect.zero
    var promptMargin: CGFloat = 0
    func resetLayout() {
        titleTextView.contentInset = UIEdgeInsets.zero
//        promptTextView.contentInset = UIEdgeInsets.zero
        detailTextView.contentInset = UIEdgeInsets.zero
        
        let fontPro = max(standardW, standardH)
        
        // title
        cardTitleBackView.frame = CGRect(center: CGPoint(x: bounds.midX, y: 27 * standardH - 6 * standardH), width: 196 * standardW, height: 54 * standardH)
        cardTitleBackView.borderWidth = rimLineWidth * 0.5
        cardTitleBackView.cornerRadius = innerCornerRadius
        cardTitleBackView.setNeedsDisplay()
        
        titleTextView.font = UIFont.systemFont(ofSize: 16 * fontPro, weight: .bold)
        titleTextView.setupWithBounding(cardTitleBackView.bounds.insetBy(dx: rimLineWidth * 0.5, dy: rimLineWidth * 0.5), shrink: false)

        let xLeft = titleTextView.frame.minX - rimFrame.minX - rimLineWidth * 2
        // stamp
        let stampLength = min(cardTitleBackView.frame.maxY - rimFrame.minY - rimLineWidth, rimFrame.maxX - xLeft)
        stamp.frame = CGRect(x: rimFrame.maxX - rimLineWidth * 1.5 - stampLength, y: rimFrame.minY + rimLineWidth, width: stampLength, height: stampLength)
        hintImageView.frame.size = CGSize(width: rimLineWidth * 4.5, height: rimLineWidth * 21) // 18 * 83
        hintImageView.frame.origin = CGPoint(x: stamp.frame.midX - hintImageView.frame.width * 0.5, y: stamp.frame.maxY)
        
        // stand position
        promptMargin = rimFrame.minX + stampLength * 0.8 + rimLineWidth
        var currentY = cardTitleBackView.frame.maxY + 2 * standardH
        
        // image
        let widthForImage = (rimFrame.width - 2 * rimLineWidth) * 0.85
        let maxBottom = rimFrame.maxY - bottomForMore - rimLineWidth
        let heightForImage = (maxBottom - currentY) * 0.75
        
        let imageY = rimFrame.maxY - rimLineWidth - heightForImage - bottomForMore
        hintImageView.isHidden = true
        
        let hintX = bounds.width - promptMargin - hintImageView.frame.width - 2 * rimLineWidth
        let remainedW = hintX - promptMargin
        // prompt
//        if withPrompt {
//            let promptFrame = CGRect(x: promptMargin, y: currentY, width: bounds.width - 2 * promptMargin, height: (imageY - currentY))
//            promptTextView.font = UIFont.systemFont(ofSize: 16 * fontPro, weight: .semibold)
//            promptTextView.setupWithBounding(promptFrame, shrink: true)
//
//            if promptTextView.needScroll {
//                hintImageView.isHidden = false
//                promptTextView.setupWithBounding(CGRect(x: promptFrame.minX, y: promptFrame.minY, width: remainedW, height: promptFrame.height), shrink: true)
//            }
//
//            currentY += promptTextView.frame.height + 5 * standardH
//        }
  
        // detail
        detailTextView.font = UIFont.systemFont(ofSize: 16 * fontPro, weight: .medium)
        let textFrame = CGRect(x: promptMargin, y: currentY, width: bounds.width - 2 * promptMargin, height: imageY - currentY - 5 * fontPro)
        detailTextView.setupWithBounding(textFrame, shrink: false)
        
        if detailTextView.needScroll {
            hintImageView.isHidden = false
            detailTextView.setupWithBounding(CGRect(x: textFrame.minX, y: textFrame.minY, width: remainedW, height: textFrame.height), shrink: false)
        }
        
        mainImageView.frame = CGRect(x: bounds.midX - widthForImage * 0.5, y: imageY, width: widthForImage, height: maxBottom - imageY)
        
        promptTag.frame = CGRect(x: rimFrame.minX, y: textFrame.maxY, width: 85 * fontPro, height: 85 * fontPro)

        // side
        // 31 * 107
        let sideSize = CGSize(width: 31 * standardW, height: 107 * standardW)
        sideBack.frame = CGRect(x: bounds.width - sideSize.width, y: bounds.height - sideSize.height - bottomForMore * 0.9, width: sideSize.width, height: sideSize.height)
        
        textScrolling = true
//        recordPromptFrame = promptTextView.frame
        recordDetailFrame = detailTextView.frame
        mainImageView.alpha = 1
    }
    
    @objc func showOrHideText(_ swipeGR: UISwipeGestureRecognizer) {
        if hintImageView.isHidden {
            return
        }
        
        if swipeGR.direction == .up && !textScrolling {
            // hide part
//            promptTextView.frame = recordPromptFrame
            detailTextView.frame = recordDetailFrame
            
//            if prompted && promptTextView.needScroll {
//                promptTextView.startTimer()
//            }
            if detailTextView.needScroll {
                detailTextView.startTimer()
            }
            
            mainImageView.alpha = 1
            hintImageView.transform = CGAffineTransform.identity
            
            textScrolling = true
        }else if swipeGR.direction == .down && textScrolling {
            // down, show all text
            var offsetY: CGFloat = 0
//            if prompted && promptTextView.needScroll {
//                promptTextView.frame.size = CGSize(width: recordPromptFrame.width, height: promptTextView.usedH)
//                promptTextView.stopScroll()
//                offsetY = promptTextView.usedH - recordPromptFrame.height
//            }
            
            detailTextView.frame.origin = CGPoint(x: recordDetailFrame.minX, y: recordDetailFrame.minY + offsetY)
            if detailTextView.needScroll {
                let maxH = mainImageView.frame.maxY - (recordDetailFrame.minY + offsetY)
                detailTextView.frame.size = CGSize(width: recordDetailFrame.width, height: min(detailTextView.usedH, maxH))

                detailTextView.stopScroll()
            }
            
            mainImageView.alpha = 0.15
            let offset = min(stamp.frame.height, hintImageView.frame.height * 65 / 81)
            hintImageView.transform = CGAffineTransform(translationX: 0, y: -offset)
            textScrolling = false
        }
    }
    
    func startToDisplay() {
        if titleTextView.needScroll {
            titleTextView.startTimer()
        }
        
//        if prompted && promptTextView.needScroll {
//            promptTextView.startTimer()
//        }
        
        if detailTextView.needScroll {
            detailTextView.startTimer()
        }
    }
    
    func endDisplay() {
        if titleTextView.needScroll {
            titleTextView.stopScroll()
        }
        
//        if prompted && promptTextView.needScroll {
//            promptTextView.stopScroll()
//        }
        
        if detailTextView.needScroll {
            detailTextView.stopScroll()
        }
    }
}

