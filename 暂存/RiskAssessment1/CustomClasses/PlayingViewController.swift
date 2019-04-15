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

    /** [categoryKey: [cardInfoKey]]*/
    var playState: [String: [String]]! {
        cachedResult.updateCurrentPlayState()
        return cachedResult.riskPlayState[dataCursor.focusingRiskKey!]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setupBarButtons()
    }
    
    // MARK: --------- title bars -------------
    let cartView = CartView()
    fileprivate let titleLabel = UILabel()
    fileprivate func setupBarButtons() {
        // sizes
        let imageLength: CGFloat = 35
        let sHeight: CGFloat = 38
        let sWidth: CGFloat = 38
        let labelWidth = width - 13 * standWP - sWidth * 3
        
        // left items: back, userView
        // back
//        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
//        spacer.width = -12
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 13 * standWP, height: 22 * standWP)
        backButton.setBackgroundImage(UIImage(named: "barButton_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        navigationController?.view.clipsToBounds = true
        
        // user, much larger than the round image
        let userView = UserDisplayView.createWithFrame(CGRect(x: 0, y: 0, width: 5 * imageLength, height: imageLength), userInfo: UserCenter.sharedCenter.currentGameTargetUser.userInfo())
        
        // right item: start over, title
        // start over
//        let rightSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
//        rightSpacer.width = -12
        
        // cart
        let cartBackFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: sWidth * 1.3, height: 44))
        let cartSpaceView = UIView(frame: cartBackFrame)
        cartView.frame = CGRect(center: CGPoint(x: cartBackFrame.midX, y: cartBackFrame.midY), width: sWidth, height: sHeight)
        setCartNumber()
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
//        titleLabel.backgroundColor = UIColor.red // check the frame
        
        // set
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: backButton), UIBarButtonItem(customView: userView)]
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: cartSpaceView),UIBarButtonItem(customView: titleLabel)]
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

    func setCartNumber() {
        cartView.number = MatchedCardsDisplayModel.getCurrentMatchedCards().count
    }
    
    // check cart
    func cartIsAdded() {
        cartView.cardAddAnimation()
        let shakeAngle = CGFloat(Double.pi) / 12
        UIView.animate(withDuration: 0.15, delay: 0.3, options: .curveLinear, animations: {
            self.cartView.transform = CGAffineTransform(rotationAngle: shakeAngle)
        }) { (true) in
            UIView.animate(withDuration: 0.15, animations: {
                self.cartView.transform = CGAffineTransform(rotationAngle: -shakeAngle)
            }) { (true) in
                self.cartView.transform = CGAffineTransform.identity
                self.setCartNumber()
            }
        }
    }

    // back
    func backButtonClicked() {
        for vc in (navigationController?.viewControllers)! {
            if vc.isKind(of: IntroPageViewController.self) {
                let _ = navigationController?.popToViewController(vc, animated: true)
                return
            }
        }
        
        self.navigationController!.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCartNumber()
    }
}
