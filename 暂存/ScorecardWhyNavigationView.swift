//
//  ScorecardWhyNavigationView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/24.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardWhyNavigationView: UIView, UIScrollViewDelegate {
    weak var scorecardWhy: ScorecardSecondView!
    fileprivate let topScrollView = UIScrollView()
    fileprivate let firstButton = UIButton(type: .custom)
    fileprivate let secondButton = UIButton(type: .custom)
    fileprivate let firstIndex = UILabel()
    fileprivate let secondIndex = UILabel()
    fileprivate let tagBack = CAGradientLayer()
    fileprivate let tagLabel = UILabel()
    fileprivate let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addView()
    }
    
    fileprivate func addView() {
        topScrollView.showsHorizontalScrollIndicator = false
        topScrollView.delegate = self
        topScrollView.isPagingEnabled = false
        
        firstButton.tag = 100
        secondButton.tag = 101
        
        firstButton.setTitle("Card Contributions to\nOverall Score", for: .normal)
        secondButton.setTitle("Complementary Cards: \nScore is not impacted by them", for: .normal)
        setTopButton(firstButton)
        setTopButton(secondButton)
        
        firstIndex.text = "1"
        secondIndex.text = "2"
        setIndex(firstIndex)
        setIndex(secondIndex)
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        tagBack.startPoint = CGPoint.zero
        tagBack.endPoint = CGPoint(x: 1, y: 0)
    
        // add all
        addSubview(topScrollView)
        topScrollView.addSubview(firstButton)
        topScrollView.addSubview(secondButton)
        addSubview(firstIndex)
        addSubview(secondIndex)
        addSubview(titleLabel)
        layer.addSublayer(tagBack)
        addSubview(tagLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.height / 166
        
        let topH = one * 62
        let bottomH = 27 * one
        
        topScrollView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: topH)
        firstButton.layer.cornerRadius = 4 * one
        secondButton.layer.cornerRadius = 4 * one
        firstButton.frame = CGRect(center: CGPoint(x: bounds.midX, y: topH * 0.5), width: bounds.width * 0.6, height: topH * 48 / 62)
        secondButton.frame = CGRect(x: firstButton.frame.maxX + topH * 0.15, y: firstButton.frame.minY, width: firstButton.frame.width, height: firstButton.frame.height)
        firstButton.layer.borderWidth = one
        secondButton.layer.borderWidth = one
        
        topScrollView.contentSize = CGSize(width: secondButton.frame.maxX + firstButton.frame.minX, height: topH)
        
        // label
        let labelL = 16 * one
        firstIndex.frame = CGRect(x: bounds.midX - labelL * 1.15, y: topH, width: labelL, height: labelL)
        secondIndex.frame = CGRect(x: bounds.midX + labelL * 0.15, y: topH, width: labelL, height: labelL)
        titleLabel.frame = CGRect(x: 0, y: firstIndex.frame.maxY, width: bounds.width, height: bounds.height - bottomH - firstIndex.frame.maxY).insetBy(dx: 5 * one, dy: 0)
        firstIndex.layer.cornerRadius = labelL * 0.5
        secondIndex.layer.cornerRadius = labelL * 0.5
        firstIndex.layer.borderWidth = one
        secondIndex.layer.borderWidth = one
        
        tagBack.frame = CGRect(x: 0, y: bounds.height - bottomH, width: bounds.width * 0.7, height: bottomH)
        let tagMask = CAShapeLayer()
        let tagPath = UIBezierPath(roundedRect: tagBack.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: bottomH * 0.5, height: bottomH * 0.5))
        tagMask.path = tagPath.cgPath
        tagBack.mask = tagMask
        tagLabel.frame = tagBack.frame.insetBy(dx: bottomH * 0.5, dy: 0)
        
        // fonts
        // buttons
        var font = UIFont.systemFont(ofSize: 12 * one)
        firstButton.titleLabel?.font = font
        secondButton.titleLabel?.font = font
        // labels
        font = UIFont.systemFont(ofSize: 12 * one, weight: .medium)
        firstIndex.font = font
        secondIndex.font = font
        tagLabel.font = font
        titleLabel.font = UIFont.systemFont(ofSize: 12 * one)
    }
    
    fileprivate func setTopButton(_ button: UIButton) {
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.layer.borderColor = UIColorFromHex(0x9F9FFF).cgColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(switchState(_:)), for: .touchUpInside)
    }
    fileprivate func setIndex(_ label: UILabel) {
        label.textAlignment = .center
        label.layer.borderColor = UIColorFromHex(0x9F9FFF).cgColor
        label.layer.masksToBounds = true
    }
    
    @objc func switchState(_ button: UIButton)  {
        setState(button.tag == 100)
    }
    
    func setState(_ first: Bool) {
        firstButton.backgroundColor = first ? UIColorFromHex(0xE1E1FF) : UIColorFromHex(0xF6F6FF)
        secondButton.backgroundColor = first ? UIColorFromHex(0xF6F6FF) : UIColorFromHex(0xE1E1FF)
        
        firstIndex.backgroundColor = firstButton.backgroundColor
        secondIndex.backgroundColor = secondButton.backgroundColor
        
        titleLabel.text = first ? "You can find out how each of your card selection choice impact the overall score calculation." : "Complementary Cards do not contribute to the scoring assessment algorithm, but they can provide you with additional actionable information and context."
        tagLabel.text = first ? "Card Score Ranking Distribution" : "Relative Risk Level"
        
        if first {
            tagBack.colors = [UIColorFromHex(0xB5B4FF).withAlphaComponent(0.9).cgColor, UIColorFromHex(0xB5B4FF).cgColor]
            tagBack.locations = [0.05, 0.1]
        }else {
            tagBack.colors = [UIColorFromHex(0x00D7FF).withAlphaComponent(0.9).cgColor, UIColorFromHex(0xB4EC51).cgColor]
            tagBack.locations = [0.05, 0.95]
        }
        
        UIView.animate(withDuration: 0.15) {
            self.topScrollView.contentOffset = CGPoint(x: first ? 0 : (self.topScrollView.contentSize.width - self.topScrollView.frame.width), y: 0)
//            let scale: CGFloat = 0.8
//            self.firstIndex.transform = first ? CGAffineTransform.identity : CGAffineTransform(scaleX: scale, y: scale)
//            self.secondIndex.transform = first ? CGAffineTransform(scaleX: scale, y: scale) : CGAffineTransform.identity
            if self.scorecardWhy != nil {
                let scrollView = self.scorecardWhy.scrollView
                scrollView.contentOffset = CGPoint(x: 0, y: first ? 0 : scrollView.bounds.height)
            }
        }
    }
    
    func hasSecond(_ has: Bool) {
        secondButton.isHidden = !has
        secondIndex.isHidden = !has
        firstButton.isUserInteractionEnabled = has
    }
    
    // scroll to change
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let max = scrollView.contentSize.width - scrollView.frame.width
        
        if offsetX > max * 0.6 {
            setState(false)
        }else {
            setState(true)
        }
    }
}
