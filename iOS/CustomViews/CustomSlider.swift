//
//  CustomSlider.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
class CustomSlider: UISlider {
    // custom silder
    var thumbImage: UIImage! {
        didSet{
            if thumbImage != oldValue {
                setThumbImage(thumbImage, for: .normal)
            }
        }
    }
    var leftTrackImage: UIImage! {
        didSet{
            if leftTrackImage != oldValue {
                setMinimumTrackImage(leftTrackImage?.resizableImage(withCapInsets: edgeInsets, resizingMode: .stretch), for: .normal)
            }
        }
    }
    var rightTrackImage: UIImage! {
        didSet{
            if rightTrackImage != oldValue {
                setMaximumTrackImage(rightTrackImage?.resizableImage(withCapInsets: edgeInsets, resizingMode: .stretch), for: .normal)
            }
        }
    }
    
    // for frame
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
    
    fileprivate let edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    fileprivate func setupBasicInfo()  {
        setMinimumTrackImage(leftTrackImage?.resizableImage(withCapInsets: edgeInsets), for: .normal)
        setMaximumTrackImage(rightTrackImage?.resizableImage(withCapInsets: edgeInsets), for: .normal)
        setThumbImage(thumbImage, for: .normal)
    }
}
