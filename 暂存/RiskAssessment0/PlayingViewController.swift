//
//  PlayingViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/24.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class PlayingViewController: UIViewController {
    // singleton
    let dataCursor = RiskMetricCardsCursor.sharedCursor
    let cachedResult = CardSelectionResults.cachedCardProcessingResults
    let cardCollection = AIDMetricCardsCollection.standardCollection
    
    var playState: [String: [String]]! {
        cachedResult.updateCurrentPlayState()
        return cachedResult.riskPlayState[dataCursor.focusingRiskKey!]
    }
    
    var mainFrame: CGRect {
        return CGRect(x: 0, y: 64, width: width, height: height - 64 - 49)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setupBarButtons()
        
    }
    
    fileprivate let cartView = CartView()
    fileprivate let titleLabel = UILabel()
    
    fileprivate func setupBarButtons() {
        // sizes
        let imageLength: CGFloat = 35
        let sHeight: CGFloat = 38
        let sWidth: CGFloat = 38
        let labelWidth = width - imageLength * 3 - sWidth
        
        // left items: back, userView
        // back
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        spacer.width = -12
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 13 * width / 375, height: 22 * width / 375)
        backButton.setBackgroundImage(UIImage(named: "barButton_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        navigationController?.view.clipsToBounds = true
        
        // user, much larger than the round image
        let userView = UserDisplayView.createWithFrame(CGRect(x: 0, y: 0, width: 5 * imageLength, height: imageLength), userInfo: UserCenter.sharedCenter.currentGameTargetUser.userInfo())
        
        // right item: start over, title
        // start over
        let rightSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        rightSpacer.width = -12
        
        // cart
        let cartBackFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: sWidth * 1.3, height: 44))
        let cartSpaceView = UIView(frame: cartBackFrame)
        cartView.frame = CGRect(center: CGPoint(x: cartBackFrame.midX, y: cartBackFrame.midY), width: sWidth, height: sHeight)
        setCartNumber(nil)
        cartView.addTarget(self, action: #selector(checkCart), for: .touchUpInside)
        cartSpaceView.addSubview(cartView)
        
        // title
        titleLabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: 44)
        let riskTypeName = cardCollection.getRiskTypeByKey(dataCursor.riskTypeKey)?.name ?? "Assessment"
        titleLabel.text = "\(dataCursor.selectedRiskClass.name ?? "") \(riskTypeName)"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        
        // set
        navigationItem.leftBarButtonItems = [spacer, UIBarButtonItem(customView: backButton), UIBarButtonItem(customView: userView)]
        navigationItem.rightBarButtonItems = [rightSpacer, UIBarButtonItem(customView: cartSpaceView),UIBarButtonItem(customView: titleLabel)]
    }
    
    
    // actions: check cart
    func checkCart() {
        if cartView.number == 0 {
            print("no card")
            
            let alert = UIAlertController(title: nil, message: "No Card\n is Answered", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Go To Answer", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        
        // check matched cards
        let cartVC = CartCardsViewController()
        cartVC.presentedFrom = self
        navigationController?.pushViewController(cartVC, animated: true)
    }

    func setCartNumber(_ number: Int?)  {
        var answered = cachedResult.numberOfCurrentCardsCached()
        if number != nil {
            // set directly
            answered += number!
        }
        
        cartView.number = answered
    }
    
    func backButtonClicked() {

    }
    
    


}
