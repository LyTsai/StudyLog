//
//  FaceViewController.swift
//  FaceIt
//
//  Created by iMac on 16/8/5.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

import UIKit

class FaceViewController: UIViewController {
    var expression: FacialExpression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smirk){
        didSet {
            updateUI()
        }
    }
        
    private var mouthCuratures = [FacialExpression.Mouth.Frown: -1.0, .Grin: 0.5, .Smile: 1.0, .Smirk: -0.5, .Neutral:0.0]
    
    private var eyeBrowTiles = [FacialExpression.EyeBrows.Relaxed: 0.5, .Furrowed: -0.5, .Normal: 0.0]
    
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(faceView.changeScale(_:))))
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            happierSwipeGestureRecognizer.direction = .Up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
 
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            sadderSwipeGestureRecognizer.direction = .Down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            faceView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(changeEyes)))
            
            updateUI()
        }
    
    }
    
    func increaseHappiness()  {
        expression.mouth = expression.mouth.happierMouth()
    }
    func decreaseHappiness()  {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    func changeEyes()  {
        switch expression.eyes {
        case .Closed:
            expression.eyes = .Open
        default:
            expression.eyes = .Closed
        }
    }
    
    
    private func updateUI() {
        switch expression.eyes {
        case .Open: faceView.eyesOpen = true
        case .Closed: faceView.eyesOpen = false
        case .Squinting: faceView.eyesOpen = false
        }
        faceView.mouthCurvature = mouthCuratures[expression.mouth] ?? 0.0
        faceView.eyeBrowTile = eyeBrowTiles[expression.eyeBrows] ?? 0.0
    }
}

class Test {
    var tree: Float
    
    init(tree: Float){
        self.tree = tree
    }
    
}