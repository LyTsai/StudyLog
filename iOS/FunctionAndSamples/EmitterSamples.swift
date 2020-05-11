//
//  EmitterSamples.swift
//  Demo_testUI
//
//  Created by L on 2020/4/24.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation

class EmitterSamples {
    // snowFlake, flower petal
    func addSnowFlakeEmitter(_ onView: UIView) {
        // emitterLayer
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: width * 0.5, y: -10)
        emitterLayer.emitterSize = UIScreen.main.bounds.size
        emitterLayer.emitterMode = .surface
        emitterLayer.emitterShape = .line
       
        // emitterCell
        let emitterCell = CAEmitterCell()
        emitterCell.birthRate = 80
        emitterCell.lifetime = 5
        emitterCell.lifetimeRange = 3
       
        emitterCell.velocity = 20
        emitterCell.velocityRange = 100
        emitterCell.yAcceleration = 50
        emitterCell.xAcceleration = 20
       
        emitterCell.emissionLongitude = -CGFloatPi
        emitterCell.emissionRange = CGFloatPi * 0.5
        
        // rotate while falling
        emitterCell.spinRange = 1.5 * CGFloatPi
       
        // color
        emitterCell.color = UIColor.white.cgColor
        emitterCell.redRange = 0.25
        emitterCell.greenRange = 0.25
        emitterCell.blueRange = 0.2
       
        // fade
        emitterCell.alphaRange = 0.75
        emitterCell.alphaSpeed = -0.15
       
        emitterCell.scale = 0.7
        emitterCell.scaleRange = 0.2
        emitterCell.scaleSpeed = -0.1
       
        // add
        emitterCell.contents = UIImage(named: "snow_flake")?.cgImage
        emitterLayer.emitterCells = [emitterCell]
       
        onView.layer.addSublayer(emitterLayer)
    }
    
    func addEmitterRunningAroundBounds(_ onView: UIView) {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.frame = bounds
        emitterLayer.emitterPosition = CGPoint.zero
        emitterLayer.emitterSize = CGSize(width: 10 * fontFactor, height: 5 * fontFactor)
        emitterLayer.emitterMode = .outline
        emitterLayer.emitterShape = .point
        emitterLayer.renderMode = .additive
        
        // cell
        let cellImage = UIImage(named: "shotting")!
        emitterCell.contents = cellImage.cgImage
        emitterCell.scale = 0.05 * bounds.height / cellImage.size.height
        emitterCell.redSpeed = 0.2
        emitterCell.greenSpeed = 0.2
        emitterCell.blueSpeed = 0.2
        emitterCell.birthRate = 30
        emitterCell.lifetime = 0.15
        emitterCell.lifetimeRange = 0.1
        
        emitterCell.velocity = 7 * fontFactor
        emitterCell.velocityRange = 4 * fontFactor
        emitterCell.alphaSpeed = -0.2
        emitterCell.emissionRange = CGFloatPi * 0.01
        
        emitterLayer.emitterCells = [emitterCell]
        
        let keyAnimation = CAKeyframeAnimation()
        let pathFrame = CGRect(x: gradientLayer.frame.minX, y: gradientLayer.frame.minY, width: gradientLayer.frame.width - 15 * fontFactor, height: gradientLayer.frame.height)
        let path = UIBezierPath()
        path.move(to: pathFrame.bottomLeftPoint)
        path.addLine(to: pathFrame.bottomRightPoint)
        path.move(to: pathFrame.topRightPoint)
        path.addLine(to: pathFrame.origin)

        keyAnimation.path = path.cgPath
        keyAnimation.repeatCount = 2000
        keyAnimation.duration = 15
        keyAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        emitterLayer.add(keyAnimation, forKey: "emitterPosition")
    }
    
}
