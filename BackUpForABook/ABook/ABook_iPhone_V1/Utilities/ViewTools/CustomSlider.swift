//
//  CustomSlider.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
class CustomSlider: UISlider {
    
    var thumbTopPoint: CGPoint {
        let thumbRect = self.thumbRect(forBounds: frame, trackRect: frame, value: value)
        return CGPoint(x: thumbRect.midX, y: thumbRect.minY)
    }
    
    func thumbX(_ forValue: Float) -> CGFloat {
        let thumbRect = self.thumbRect(forBounds: frame, trackRect: frame, value: forValue)
        return thumbRect.midX
    }
    
    // init
    override init(frame: CGRect){
        super.init(frame: frame)
        setupBasicInfo()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setupBasicInfo()
    }
    
    fileprivate func setupBasicInfo()  {
        let edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let thumbImage = UIImage(named: "sliderThumb")
        let trackImage = UIImage(named: "sliderTrack")?.resizableImage(withCapInsets: edgeInsets)
        
        setMinimumTrackImage(trackImage, for: .normal)
        setMaximumTrackImage(trackImage, for: .normal)
        setThumbImage(thumbImage, for: .normal)
    }

}
