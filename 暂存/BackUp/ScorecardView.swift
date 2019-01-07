//
//  ScorecardView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/17.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

// 345 * 518
class ScorecardView: UIView {
    @IBOutlet weak var overallView: ScorecardFirstView!
    
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var detailBackView: UIView!
    @IBOutlet weak var checkLabel: UILabel!
    
    var detailView = ScorecardDetailView()
 
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
        loadViewFromNib()
    }
    
    fileprivate var view: UIView!
    fileprivate func loadViewFromNib() {
        let nib = UINib(nibName: String(describing: ScorecardView.self), bundle: Bundle(for: ScorecardView.self))
        view = nib.instantiate(withOwner: self, options: nil).first! as! UIView
        addSubview(view)
        setupBasic()
    }

    // add views
    // width / 345
    fileprivate func setupBasic() {
        layer.masksToBounds = true
        
        // add extra views
        addSubview(detailView)
        
        // tap gesture
        let tapDetailGR = UITapGestureRecognizer(target: self, action: #selector(showOrHide))
        detailBackView.addGestureRecognizer(tapDetailGR)
    }
    
    // data
    fileprivate var riskKey: String!
    fileprivate var userKey: String!
    func setupWithRisk(_ riskKey: String, userKey: String) {
        self.riskKey = riskKey
        self.userKey = userKey
    
        showDetail = false
        setupState()
        
        // data
        overallView.setupWithRisk(riskKey, userKey: userKey)
        detailView.setupWithRisk(riskKey, userKey: userKey)
    }

    
    // frames
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustSizes()
        
        view.frame = bounds
        view.layoutSubviews()
        overallView.layoutIfNeeded()
        
        if !showDetail {
            detailView.frame = CGRect(x: 0, y: detailBackView.frame.maxY, width: bounds.width, height: offset)
        }
    }
    
    fileprivate func adjustSizes() {
        let realFactor = bounds.width / 345
        
        // fonts
        checkLabel.font =  UIFont.systemFont(ofSize: 12 * realFactor, weight: UIFontWeightMedium)
        
        // border
        layer.cornerRadius = 8 * realFactor
    }
    
    fileprivate var showDetail = false
    func showOrHide() {
        showDetail = !showDetail
        UIView.animate(withDuration: 0.5) {
            self.setupState()
        }
    }
    fileprivate var offset: CGFloat {
        return bounds.height - detailBackView.bounds.height + checkLabel.frame.maxY
    }
    
    fileprivate func setupState() {
        let transform = showDetail ? CGAffineTransform(translationX: 0, y: -offset) : CGAffineTransform.identity
        detailView.transform = transform
        detailBackView.transform = transform
        arrow.transform = showDetail ? CGAffineTransform(rotationAngle: CGFloat(Double.pi)) : CGAffineTransform.identity
    }
}
