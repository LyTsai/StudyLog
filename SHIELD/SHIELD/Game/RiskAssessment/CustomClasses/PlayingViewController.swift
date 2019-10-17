//
//  PlayingViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/24.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class PlayingViewController: UIViewController {
    var backImage: UIImage! {
        didSet{
            backImageView.image = backImage
        }
    }
    
    var playerReachable: Bool {
        return true
    }
    
    var withCartIcon: Bool {
        return true
    }
    
    fileprivate let backImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        backImageView.frame = view.bounds
        view.addSubview(backImageView)
        
        setupBarButtons()
    }
    
    // MARK: --------- title bars -------------
    var cartNumber: Int {
        return cartView.number
    }
    fileprivate let cartView = CartView()
    fileprivate let playerButton = PlayerButton.createForNavigationItem()
    fileprivate let titleView = StrokeLabel()
    fileprivate func setupBarButtons() {
        // left items: 
        let backButton = createBackButton()
        navigationController?.view.clipsToBounds = true
        
        // cart, 38 * 38
        let cartBackFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 38 * 1.2, height: 44))
        let cartSpaceView = UIView(frame: cartBackFrame)
        cartView.frame = CGRect(center: CGPoint(x: cartBackFrame.midX, y: cartBackFrame.midY), width: 38, height: 38)
        cartView.addTarget(self, action: #selector(checkCart), for: .touchUpInside)
        cartSpaceView.addSubview(cartView)
        
        // title
        titleView.frontColor = UIColor.black
        titleView.strokeColor = UIColor.white
        navigationItem.titleView = titleView
        
        // set
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        var rightItems = [UIBarButtonItem(customView: playerButton)]
        if withCartIcon {
            rightItems.append(UIBarButtonItem(customView: cartSpaceView))
        }
        
        navigationItem.rightBarButtonItems = rightItems
        playerButton.isUserInteractionEnabled = playerReachable
        playerButton.buttonAction = playerIsTouched
    }
    
    func playerIsTouched() {
        let alert = CatCardAlertViewController()
        alert.addTitle("You will go to choose another player", subTitle: nil, buttonInfo:[("Go To Choose", false, choosePlayer), ("Cancel", true, nil)])
        presentOverCurrentViewController(alert, completion: nil)
    }
    
    fileprivate func choosePlayer() {
        let playerVC = ABookPlayerViewController.initFromStoryBoard()
        playerVC.backToIntroAfterChoose = true
        self.navigationController?.pushViewController(playerVC, animated: true)
    }
    
    
    // actions: check cart
    @objc func checkCart() {
        if cartNumber == 0 {
            print("no card")
            
            let alert = UIAlertController(title: nil, message: "No Card\n is Selected", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Go To Play Cards", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        
        // check matched cards
        let summary = SummaryViewController()
        summary.forCart = true
        navigationController?.pushViewController(summary, animated: true)
    }

    func setCartNumber() {
        if let riskKey = cardsCursor.focusingRiskKey {
            // number read
            let all = collection.getAllDisplayCardsOfRisk(riskKey)
            cartView.number = MatchedCardsDisplayModel.getCurrentMatchedCardsFromCards(all).count
        }
    }
    
    fileprivate func setTitle() {
        if let riskKey = cardsCursor.focusingRiskKey {
            let risk = collection.getRisk(riskKey)!
            titleView.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            titleView.text = risk.name
        }
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

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setCartNumber()
        setTitle()
        playerButton.setWithCurrentUser()
    }
}
