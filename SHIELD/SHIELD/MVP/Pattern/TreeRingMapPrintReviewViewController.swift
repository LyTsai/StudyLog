//
//  TreeRingMapPrintReviewViewController.swift
//  AnnielyticX
//
//  Created by L on 2019/5/30.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class TreeRingMapPrintReviewViewController: UIViewController {
    weak var treeRingMapVC: TreeRingMapViewController!
    
    @IBOutlet weak var printView: UIView!
    @IBOutlet weak var treeRingMapImage: UIImageView!
    @IBOutlet weak var cancelButton: GradientBackStrokeButton!
    @IBOutlet weak var printButton: GradientBackStrokeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.setupWithTitle("Cancel")
        cancelButton.isSelected = false
        
        printButton.setupWithTitle("Print")
    }
    
    
    fileprivate var review: UIImage!
    func setWithImage(_ image: UIImage?) {
        treeRingMapImage.image = image
        self.review = image
        print(image!.size)
        modalTransitionStyle = .crossDissolve
    }
    
    @IBAction func cancelPrint(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func print(_ sender: Any) {
        dismiss(animated: true) {
            if self.treeRingMapVC != nil && self.review != nil{
                self.treeRingMapVC.printImage(self.review)
            }
        }
    }
    
}
