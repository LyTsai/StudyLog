//
//  OverallHealthInputView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/8.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
/*
 total: 44 * 78
 image: 44 * 44 (47, chosen)
 labelH: 18
 lineH: 10
 */
class HealthStateView: UIView {
    var isChosen = false {
        didSet{
            if isChosen != oldValue {
                setupWithChosen(isChosen)
            }
        }
    }
    var healthState = HealthState.good {
        didSet{
            if healthState != oldValue {
                setupWithHealthState(healthState)
            }
        }
    }
    
    class func createWith(_ frame: CGRect) -> HealthStateView {
        let stateView = HealthStateView(frame: frame)
        stateView.setup()
        
        return stateView
    }
    
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    private let lineView = UIView()
    
    private func setup() {
        backgroundColor = UIColor.clear
        
        let basicColor = UIColorGray(178)
        textLabel.textAlignment = .center
        textLabel.textColor = basicColor
        
        lineView.backgroundColor = basicColor
        
        imageView.contentMode = .scaleAspectFit
        
        addSubview(imageView)
        addSubview(textLabel)
        addSubview(lineView)
        
        setupWithHealthState(.good)
        setupWithChosen(false)
    }
    
    private func setupWithHealthState(_ state: HealthState) {
        switch state {
        case .good:
            textLabel.text = "Good"
            imageView.image = UIImage(named: "state_good_un")
        case .ok:
            textLabel.text = "OK"
            imageView.image = UIImage(named: "state_ok_un")
        case .poor:
            textLabel.text = "Poor"
            imageView.image = UIImage(named: "state_poor_un")
        }
    }
    
    private func setupWithChosen(_ chosen: Bool) {
        switch healthState {
        case .good:
            imageView.image = chosen ? UIImage(named: "state_good"): UIImage(named: "state_good_un")
        case .ok:
            imageView.image = chosen ? UIImage(named: "state_ok"): UIImage(named: "state_ok_un")
        case .poor:
            imageView.image = chosen ? UIImage(named: "state_poor"): UIImage(named: "state_poor_un")
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width * 47 / 44)
        
        let lineHeight = 10 * bounds.height / 78
        let labelHeight = 18 * bounds.height / 78
        
        lineView.frame = CGRect(x: bounds.midX - 1, y: bounds.height - lineHeight, width: 2, height: lineHeight)
        textLabel.frame = CGRect(x: 0, y: bounds.height - labelHeight - lineHeight, width: bounds.width, height: labelHeight)
        textLabel.font = UIFont.systemFont(ofSize: labelHeight / 2.2)
    }
}

// MARK: ------------------- overall
class OverallHealthInputView: UIView {
    var result: HealthState!
    
    var hostCell: UserInfoOverallHealthCell!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    fileprivate let slider = CustomSlider()
    
    fileprivate let goodView = HealthStateView.createWith(CGRect.zero)
    fileprivate let okView = HealthStateView.createWith(CGRect.zero)
    fileprivate let poorView = HealthStateView.createWith(CGRect.zero)
    
    fileprivate func setupBasic() {
        backgroundColor = UIColor.clear
        
        goodView.healthState = .good
        okView.healthState = .ok
        poorView.healthState = .poor
        
        slider.value = 0
        slider.addTarget(self, action: #selector(selectOverall), for: .valueChanged)
    
        addSubview(slider)
        addSubview(goodView)
        addSubview(okView)
        addSubview(poorView)
    }
    
    func selectOverall() {
        if hostCell != nil {
            hostCell.changeState()
        }
        
        // select
        if slider.value < 0.3 {
            goodView.isChosen = true
            okView.isChosen = false
            poorView.isChosen = false
            
            result = .good
        }else if slider.value < 0.6 {
            goodView.isChosen = false
            okView.isChosen = true
            poorView.isChosen = false
            
            result = .ok
        }else {
            goodView.isChosen = false
            okView.isChosen = false
            poorView.isChosen = true
            
            result = .poor
        }
    }
    

    /*
     total: 174 * 99
     slider: 150 * 30 (adjust)
     
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let sWidth = bounds.width * 150 / 174
        let sHeight = bounds.height * 0.32
        
        let stateHeight = bounds.height - sHeight
        let stateWidth = bounds.width * 44 / 174
        
        slider.frame = CGRect(x: (bounds.width - sWidth) * 0.5, y: stateHeight, width: sWidth, height: sHeight)
        
        goodView.frame = CGRect(x: slider.thumbX(0) - stateWidth * 0.5, y: 0, width: stateWidth, height: stateHeight)
        okView.frame = CGRect(x: slider.thumbX(0.5) - stateWidth * 0.5, y: 0, width: stateWidth, height: stateHeight)
        poorView.frame = CGRect(x: slider.thumbX(1) - stateWidth * 0.5, y: 0, width: stateWidth, height: stateHeight)
        
    }

}
