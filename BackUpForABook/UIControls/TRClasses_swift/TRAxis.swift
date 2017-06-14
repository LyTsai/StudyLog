//
//  TRAxis.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

// a super class of row and column

class TRAxis: NSObject {
    var tickLabelDirection: TickLabelOrientation?
    var showLabel: Bool?
    var showTicks: Bool?
    
    var eyeRadius: Float?
    var eyeTicks: Int?
    var eyePosition: Float?
    var fishyEye: Bool?
    var lastTickValue: Float?
    var firstTickValue: Float?
    var spaceBetweenAxisAndLabel: Int?
    var labelMargin: Float?
    var maxNumberOfFullSizeLetters: Int?
    
    var uniformFontSize: Bool?
    var fontSizeLarge: Float?
    var fontSizeSmall: Float?
    var fontSize_Remainder: Float?
    
    var ticks = [TRAxisTick]()
    var tickColor: UIColor?
    var tickSize: Float?
    var height: Float?
    var fishEyeNeeded: Bool?
    var numberOfTicks: Int?
    
    // start and end of axis value range
    var min: Float?
    var max: Float?
    
    // unit font size
    var pointsPerFontSize: Float?
    var axStyle: AxisTickStyle?

    override init() {
        super.init()
        pointsPerFontSize = 1.0
        showLabel = false
        showTicks = false
        tickColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
        tickSize = 0.5
        height = 3
        axStyle = .even
        uniformFontSize = false
        fontSizeLarge = 10.0
        fontSizeSmall = 8.0
        fontSize_Remainder = 8.0
        maxNumberOfFullSizeLetters = 28
        min = 0.0
        max = 90.0
        numberOfTicks = ticks.count
        firstTickValue = min
        lastTickValue = max
        tickLabelDirection = .zero
        spaceBetweenAxisAndLabel = 6
        labelMargin = 80
        fishyEye = true
        eyePosition = (firstTickValue! + lastTickValue!) * 0.5
        eyeRadius = 50
        eyeTicks = 5
        fishEyeNeeded = false
    }
    
    
    func setTickLabelFonts(_ uniform: Bool, large: Float, small: Float){
        uniformFontSize = uniform
        fontSizeLarge = large
        fontSizeSmall = small
        fontSize_Remainder = small
        updateTickFonts()
    }
    
    func updateTickFonts(){
        for tick in ticks{
            if tick.label == nil{continue}
            tick.label?.fontSizeLarge = fontSizeLarge
            tick.label?.fontSizeSmall = fontSizeSmall
            tick.label?.fontSize_Remainder = fontSize_Remainder
            tick.label?.maxNumberOfFullSizeLetters = maxNumberOfFullSizeLetters
            tick.label?.updateAttributedString()
        }
    }
    
    // methods of getting axis information
    func position(_ index: Int) -> Float{
        if index >= ticks.count{
            return max!
        }
        if index < 0{
            return min!
        }
        return ticks[index].viewOffset!
    }
    
    func setAxisTicks(_ axMin: Float, axMax: Float, tickLabels: [String], firstTick: Float, lastTick: Float){
        min = axMin
        max = axMax
        firstTickValue = firstTick
        lastTickValue = lastTick
        ticks = [TRAxisTick]()
        for i in 0..<tickLabels.count{
            let oneTick = TRAxisTick.init()
            oneTick.label?.shortString = tickLabels[i]
            oneTick.label?.fullString = tickLabels[i]
            ticks.append(oneTick)
        }
        
        numberOfTicks = ticks.count
        
        reSize()
        
        updateTickFonts()
    }
    
    func reSize(){
        fishEyeNeeded = false
        if axStyle == .even{
            if fishyEye == true{
                reSize_FishEye()
            }else{
                reSize_Even()
            }
        }
    }
    
    func reSize_Even(){
        var delta = lastTickValue! - firstTickValue!
        if ticks.count > 1{
            delta = (lastTickValue! - firstTickValue!) / Float(ticks.count - 1)
        }
        for i in 0..<ticks.count{
            let oneTick = ticks[i]
            oneTick.gridIndex = i
            oneTick.viewOffset = Float(i) * delta + firstTickValue!
            oneTick.viewSpace = Float(spaceBetweenAxisAndLabel!) * pointsPerFontSize!
        }
    }
    
    func reSize_FishEye(){
        reSize_Even()
        let delta = (lastTickValue! - firstTickValue!) / Float(ticks.count - 1)
        let effectiveRadius = effective_Radius(delta)
        if ticks.count <= 1 || eyeTicks! <= 1 || (Float(2) * effectiveRadius / Float(eyeTicks!)) <= delta{
            fishEyeNeeded = false
            return
        }
        
        fishEyeNeeded = true
        let denl = (lastTickValue! - firstTickValue! - 2 * effectiveRadius) / Float(ticks.count - eyeTicks! - 1)
        let denr = denl
        let denm = 2 * effectiveRadius / Float(eyeTicks!)
        if (eyePosition! + effectiveRadius) > (lastTickValue! - denl){
            eyePosition = lastTickValue! - effectiveRadius - denl
        }else if (eyePosition! - effectiveRadius) < (firstTickValue! + denr){
            eyePosition = firstTickValue! + effectiveRadius + denr
        }
        
        let eyel = (eyePosition! - effectiveRadius - firstTickValue!) / denl
        let eyer = eyel + Float(eyeTicks!)
        
        var prevPos = firstTickValue! - denl
        var deltaidx: Float
        
        for i in 0..<ticks.count{
            let tick = ticks[i]
            if Float(i) < eyel{
                tick.viewOffset = prevPos + denl
                prevPos = prevPos + denl
            }else if Float(i) > eyer{
                if (Float(i) - eyer) < 1.0{
                    deltaidx = eyer - Float(Int(eyer))
                    prevPos = eyePosition! + effectiveRadius - deltaidx * denr
                }
                tick.viewOffset = prevPos + denr
                prevPos = prevPos + denr
            }else{
                if (Float(i) - eyel) < 1.0{
                    deltaidx = eyel - Float(Int(eyel))
                    prevPos = eyePosition! - effectiveRadius - deltaidx * denm
                }
                tick.viewOffset = prevPos + denm
                prevPos = prevPos + denm
            }
        }
    }
    
    func effective_Radius(_ delta: Float) -> Float{
        if Float(eyeRadius! * pointsPerFontSize!) >= Float(abs((lastTickValue! - firstTickValue!) * Float(0.5) - 2 * delta)){
            return Float(abs((lastTickValue! - firstTickValue!) * Float(0.5) - 2 * delta))
        
        }else{
            return Float(eyeRadius! * pointsPerFontSize!)
        
        }
    }

}
