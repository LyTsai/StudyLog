//
//  File.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/29.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import Kingfisher
import SDWebImage

// only texts and image, used on many cards
class PlainCardView: UIView, UITextViewDelegate {
    // MARK: --------- properties -------------------
    // open, fill data
    var title = "" {
        didSet{ titleLabel.text = title}
    }
    
    var prompt = "" {
        didSet{
            promptLabel.text = prompt
        }
    }
    
    var detail = "" {
        didSet{ detailLabel.text = detail }
    }
    
    var side = "" {
        didSet{ sideLabel.text = side }
    }
    
    var mainImageUrl: URL! {
        didSet{
            if mainImageUrl == nil  {
                self.mainImageView.image = ProjectImages.sharedImage.placeHolder
                return
            }
//            mainImageView.kf.indicatorType = .activity
//            mainImageView.kf.setImage(with: ImageResource.init(downloadURL: mainImageUrl!), placeholder: ProjectImages.sharedImage.indicator, options: [KingfisherOptionsInfoItem.transition(ImageTransition.fade(1)), KingfisherOptionsInfoItem.cacheMemoryOnly], progressBlock: nil, completionHandler: nil)
            
            mainImageView.sd_setShowActivityIndicatorView(true)
            mainImageView.sd_setIndicatorStyle(.gray)
            mainImageView.sd_setImage(with: mainImageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached ,progress: nil) { (image, error, type, url) in
                
                if image == nil {
                    self.mainImageView.image = ProjectImages.sharedImage.placeHolder
                }else {

                }
            }
        }
    }
    
    var mainImage = UIImage(named: "Coming Soon.png") {
        didSet{ mainImageView.image = mainImage }
    }
    
    // hint
    let hintButton = UIButton(type: .custom)
    let hintPersonImageView = UIImageView()
    
    // size concerned, change with the backImage
    fileprivate var standardW: CGFloat {
        return bounds.width / 335
    }
    fileprivate var standardH: CGFloat {
        return bounds.height / 448
    }
    
    var lineInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 18 * standardH, left: 10 * standardW, bottom: 14 * standardH, right: 10 * standardW)
    }
    
    var lineWidth: CGFloat {
        return 4 * max(standardH, standardW)
    }

    var bottomForMore: CGFloat {
        return 55 * standardH
    }
    
    // in case there is more change about the textLabel or imageView
    let titleLabel = UILabel()
    let promptLabel = UITextView()
//        UILabel()
    let detailLabel = UITextView()
//        UILabel()
    let mainImageView = UIImageView()
    
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
    fileprivate let sideLabel = UILabel()
//    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate func updateUI() {
        for view in subviews {
            view.removeFromSuperview()
        }
        layer.sublayers = nil
        withPrompt = false
        
        // setup titleLabel
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColorFromRGB(69, green: 51, blue: 17)
        
        // setup detailLabel
//        detailLabel.numberOfLines = 0
        detailLabel.isEditable = false
        detailLabel.textAlignment = .center
        detailLabel.backgroundColor = UIColor.clear
        detailLabel.delegate = self

        // gradient layer
//        gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0.2).cgColor]
//        gradientLayer.startPoint = CGPoint.zero
//        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
//        gradientLayer.locations = [0.7, 0.95]
//        gradientLayer.isHidden = true
     
        // setup side
        sideBack.image = ProjectImages.sharedImage.cardSide
//        sideBack.contentMode = .scaleToFill
        
        sideLabel.numberOfLines = 0
        sideLabel.textAlignment = .center
        sideLabel.backgroundColor = UIColor.clear
        
        // setup imageView
        mainImageView.contentMode = .scaleAspectFit
        
        
        // hint
        hintButton.imageView?.contentMode = .scaleAspectFit
        hintPersonImageView.contentMode = .scaleAspectFit
        
        // add
        addSubview(mainImageView)
        addSubview(titleLabel)
//        layer.addSublayer(gradientLayer)
        addSubview(detailLabel)
        addSubview(sideBack)
//        addSubview(sideLabel)
        
        addSubview(hintButton)
        addSubview(hintPersonImageView)
        
//        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (timer) in
//            self.detailLabel.scrollRectToVisible(self.detailLabel.frame, animated: true)
//
//            timer.invalidate()
//        }
    }
    
    
    // for prompt
    var prompted: Bool {
        return withPrompt
    }
    
    fileprivate var withPrompt = false
    func addSetForPrompt() {
        withPrompt = true
        
        // prompt label
//        promptLabel.numberOfLines = 0
        promptLabel.textAlignment = .center
        promptLabel.backgroundColor = UIColor.clear
        promptLabel.isEditable = false
        promptLabel.delegate = self
        // text colors
        
//        titleLabel.textColor = UIColorFromRGB(69, green: 51, blue: 17)
        if promptLabel.superview == nil {
            addSubview(promptLabel)
        }
    }
    
    func removePrompt() {
        promptLabel.removeFromSuperview()
        withPrompt = false
    }
    
    func hideSide(_ hide: Bool) {
        sideLabel.isHidden = hide
        sideBack.isHidden = hide
    }
    
    // layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        resetLayout()
    }
    
    // call when the layout is changed, except from the frame of view is changed
    func resetLayout() {
        // title, x: 74, width: 187
        titleLabel.frame = CGRect(x: 74.5 * standardW, y: 0, width: 186 * standardW, height: 48 * standardH)
        titleLabel.font = UIFont.systemFont(ofSize: min(18, 18 * standardH), weight: UIFontWeightBold)

        // stand position
        let promptMargin = 2 * lineInsets.left + lineWidth
        var promptY = 40 * standardH + lineInsets.top
        
        // image
        let widthForImage = bounds.width - lineInsets.left - lineInsets.right - 2 * lineWidth - 2.4 * lineInsets.top
        let heightForImage = bounds.height - promptY - bottomForMore - lineInsets.bottom - lineWidth - 0.2 * lineInsets.top
        
        let imageLength = min(widthForImage, heightForImage) * 0.84
        let imageY = bounds.height - imageLength - bottomForMore - lineInsets.bottom - 0.2 * lineInsets.top
        
        mainImageView.frame = CGRect(x: bounds.midX - imageLength * 0.5, y: imageY, width: imageLength, height: imageLength)
        
        // prompt
        if withPrompt {
            promptY -= lineInsets.top * 0.3
            promptLabel.frame = CGRect(x: promptMargin, y: promptY, width: bounds.width - 2 * promptMargin, height: (imageY - promptY))
            promptLabel.font = UIFont.systemFont(ofSize: min(18, 18 * standardH), weight: UIFontWeightBold)
            promptLabel.sizeToFit()
            promptLabel.frame = CGRect(x: promptMargin, y: promptY, width: bounds.width - 2 * promptMargin, height: min(imageY - promptY, promptLabel.frame.height))
//            promptLabel.adjustWithWidthKept()
            promptY += promptLabel.frame.height + 5 * standardH
        }
        
        // detail
        let textFrame = CGRect(x: promptMargin, y: promptY, width: bounds.width - 2 * promptMargin, height: imageY - promptY)
        detailLabel.frame = textFrame
        detailLabel.font = UIFont.systemFont(ofSize: min(16, 16 * standardH))
//        detailLabel.adjustWithWidthKept()
        
//        if detailLabel.frame.maxY > imageY {
//            // show mask for image
//            gradientLayer.isHidden = false
//            gradientLayer.frame = CGRect(x: promptMargin, y: imageY, width: bounds.width - 2 * promptMargin, height: detailLabel.frame.maxY - imageY)
//        }else {
//            gradientLayer.isHidden = true
//        }
        
        // side
        // 31 * 107
        let sideSize = CGSize(width: 31 * standardW, height: 107 * standardW)
        sideBack.frame = CGRect(x: bounds.width - sideSize.width, y: bounds.height - sideSize.height - bottomForMore * 0.7, width: sideSize.width, height: sideSize.height)
        
        sideLabel.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        sideLabel.frame = sideBack.frame
        sideLabel.font = UIFont.systemFont(ofSize: min(10, sideSize.width * 0.32), weight: UIFontWeightMedium)
    }
    
    func isTextViewScrollable(_ textView: UITextView) -> Bool {
        return textView.frame.height < textView.contentSize.height
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for view in detailLabel.subviews {
            if view.isKind(of: UIImageView.self) && view.autoresizingMask == .flexibleLeftMargin {
                view.alpha = 1
            }
        }
    }
    
}
