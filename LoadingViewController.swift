//
//  LoadingViewController.swift
//  FacialRejuvenationByDesign
//
//  Created by L on 2019/6/12.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation

class LoadingViewController: UIViewController {
    @IBOutlet weak var rotateImageView: UIImageView!
    
    @IBOutlet weak var resignButton: CustomColorButton!
    
    class func createFromNib() -> LoadingViewController {
        let loadingVC = Bundle.main.loadNibNamed("LoadingViewController", owner: self, options: nil)?.first as! LoadingViewController
        return loadingVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resignButton.isSelected = true
        resignButton.isHidden = true
    }
    
    // read only
    var isLoading: Bool {
        return _isLoading
    }
    var _isLoading = false
    
    fileprivate var onshowTimer: Timer!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _isLoading = true
        rotateImageView.image = UIImage.animatedImageNamed("loading_0", duration: 1)

        var number = 0
        onshowTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            number += 1
            if number >= 5 {
                self.resignButton.isHidden = false
                timer.invalidate()
            }
        })
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true) {
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _isLoading = false

        if onshowTimer != nil {
            onshowTimer.invalidate()
            onshowTimer = nil
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
//    func completionAction(_ action: (()->Void)?)  {
//        if isLoading {
//            dismiss(animated: true) {
//                action?()
//            }
//        }else {
//            action?()
//        }
//    }
}
