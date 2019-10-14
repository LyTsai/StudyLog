//
//  TabTagDiscriptionView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/28.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class TabTagDiscriptionView: UIView {
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let textLabel = UILabel()
    fileprivate let imageView = UIImageView()
    fileprivate let emitterLayer = CAEmitterLayer()
    fileprivate let emitterCell = CAEmitterCell()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBasic()
    }
    
    // add subviews(layer)
    fileprivate func addBasic() {
        // gradientBack
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0.05, 0.95]
        gradientLayer.borderColor = UIColor.black.cgColor
        
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        
        imageView.contentMode = .scaleAspectFit
        
        layer.addSublayer(gradientLayer)
        addSubview(textLabel)
        layer.addSublayer(emitterLayer)
        addSubview(imageView)
    }
    
    func setupWithTopColor(_ topColor: UIColor, bottomColor: UIColor, text: String, image: UIImage?)  {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        textLabel.text = text
        imageView.image = image
        
        emitterCell.color = bottomColor.cgColor
    }
    
    func prepareForAnimation(_ labelRatio: CGFloat, leftFix: Bool, moveImage: Bool) {
        textLabel.text = ""
        let remainedWidth = max(textLabel.frame.width * labelRatio, bounds.height)
        gradientLayer.frame = CGRect(x: leftFix ? gradientLayer.frame.minX : gradientLayer.frame.maxX - remainedWidth, y: gradientLayer.frame.minY, width: remainedWidth, height: gradientLayer.frame.height)
        imageView.center = CGPoint(x: moveImage ? bounds.width - bounds.midY : gradientLayer.frame.minX, y: bounds.midY)
    }
    
    func prepared() {
        let layerHeight = gradientLayer.frame.height
        gradientLayer.frame = CGRect(center: imageView.center, length: layerHeight)
        gradientLayer.cornerRadius = layerHeight * 0.5
        imageView.frame = CGRect(center: imageView.center, length: layerHeight / sqrt(2))
        
        // change emitter
        emitterLayer.removeAllAnimations()
        emitterLayer.emitterPosition = CGPoint(x: gradientLayer.position.x, y: 0)
        emitterLayer.emitterSize = CGSize(width: imageView.frame.width * 0.8, height: 0)

        // shotting
        let cellImage = UIImage(named: "shotting_1")!
        emitterCell.contents = cellImage.cgImage
        
        emitterCell.scale = 0.2 * imageView.frame.width / cellImage.size.width
        emitterCell.velocity = 5 * fontFactor
        emitterCell.velocityRange = 2 * fontFactor
        emitterCell.xAcceleration = 0
        emitterCell.birthRate = 5
        emitterCell.lifetime = 1
        emitterCell.scaleSpeed = -0.01
    }
    
    func duringMove() {
        gradientLayer.isHidden = true
        imageView.frame = CGRect(center: imageView.center, length: bounds.height * 0.4)
    }

    // layout
    func layoutSubFrames() {
        gradientLayer.isHidden = false
        
        let lineWidth = bounds.height / 40
        let imageL = bounds.height * 0.7
        imageView.frame = CGRect(x: 0, y: (bounds.height - imageL) * 0.5, width: imageL, height: imageL)
        gradientLayer.frame = CGRect(x: imageView.frame.midX, y: lineWidth * 0.5, width: bounds.width - imageView.frame.midX - lineWidth * 0.5, height: bounds.height - lineWidth)
        gradientLayer.borderWidth = lineWidth
        gradientLayer.cornerRadius = 3 * lineWidth
        textLabel.frame = gradientLayer.frame.insetBy(dx: bounds.midY, dy: lineWidth * 0.5)
        textLabel.font = UIFont.systemFont(ofSize: min(7 * lineWidth, 14 * fontFactor), weight: .medium)
        
        // emitter
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
