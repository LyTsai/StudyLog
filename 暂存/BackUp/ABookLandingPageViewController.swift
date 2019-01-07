//
//  ABookLandingPageViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/1/10.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class ABookLandingPageViewController: UIViewController {
    var selectedRiskClass: String!
    var landing: LandingPageTireView!
    var arcButtons = ArcButtonsView()
    // text in label
    var chosenTitle: String! {
        didSet{
            titleLabel.text = chosenTitle
        }
    }
    // arc text
    var detailTitle: String! {
        didSet{
            if detailTitle != oldValue {
                 detailDraw.text = detailTitle
            }
        }
    }

    fileprivate var riskTypes: [RiskTypeObjModel] {
        return AIDMetricCardsCollection.standardCollection.getAllRiskTypes()
    }
    
    fileprivate let titleLabel = UILabel()
    fileprivate let detailDraw = ArcTextDrawView()
    
    // MARK: ------- methods ---------------
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.contents = UIImage(named: "landingPageBack")?.cgImage
        // barbuttons
        createBarButtons()
        createHomePlate()
    }
    
    // create subviews
    fileprivate func createHomePlate() {
        // selected index
        var tireIndex = -1
        if let tabbar = tabBarController as? ABookTabBarController {
            tireIndex = tabbar.tireIndex
        }
        
        // frames
        let plateLength = min(mainFrame.width, mainFrame.height - 55 * standHP * 2)
        let gap = (mainFrame.height - plateLength) * 0.5
        let offsetY: CGFloat = 0
        let buttonSpace = gap * 0.78
        
        // titleLabel
        titleLabel.textColor = UIColor.white
        titleLabel.frame = CGRect(x: width * 0.03, y: mainFrame.minY, width: width * 0.94, height: gap)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: max(gap * 0.32, 18), weight: UIFontWeightSemibold)
        
        // buttons  #imageLiteral(resourceName: "buttonBack_riskType")
        var buttons = [CustomButton]()
        for riskType in riskTypes {
            let button = CustomButton(type: .custom)
            button.key = riskType.key
            button.backImage = UIImage(named: "buttonBack_riskType")
            
            // break string
            let name = riskType.name ?? "iRa Risk"
            let index = name.index(name.startIndex, offsetBy: 3)
            let typeName = name.substring(to: index)
            let leftIndex = name.index(name.startIndex, offsetBy: 4)
            let leftString = name.substring(from: leftIndex)
            
            button.addTitle(leftString)
            button.addPrompt(typeName)
            
            button.addTarget(self, action: #selector(goToGames), for: .touchUpInside)
            buttons.append(button)
        }
        
        arcButtons.setRectBackWithFrame(mainFrame, buttons: buttons, minRadius: mainFrame.height * 0.5 - buttonSpace, buttonGap: 0.03, buttonScale: 0.9)
        
        // draw text
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: (gap - buttonSpace) * 0.8, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor.white]
        detailDraw.setTopArcWithFrame(CGRect(x: 0, y: mainFrame.minY + buttonSpace, width: width, height: mainFrame.height - buttonSpace * 2), angle: CGFloat(Double.pi), minRadius: plateLength * 0.5 * 365 / 375, attributes: attributes)
        detailDraw.layer.addBlackShadow(0)
        detailDraw.layer.shadowOffset = CGSize.zero

        // plate
        landing = LandingPageTireView.createWithFrame(CGRect(center: CGPoint(x: mainFrame.midX, y: mainFrame.midY), length: plateLength), offsetY: offsetY)
        landing.hostVC = self
        
        // bottom
        // buttons
        let imageWidth = min(gap, 40 * standWP)
        let bottomHMargin = 2 * imageWidth
        let imageSize = CGSize(width: imageWidth, height: imageWidth)
        let protectButton = UIButton(type: .custom)
        let petButton = UIButton(type: .custom)
        protectButton.setImage(UIImage(named: "protectView"), for: .normal)
        petButton.setImage(UIImage(named: "petView"), for: .normal)
        
        let buttonsX = width - 1.5 * imageWidth
        protectButton.frame = CGRect(origin: CGPoint(x: buttonsX, y: mainFrame.maxY - imageWidth * 2.7), size: imageSize)
        petButton.frame = CGRect(origin: CGPoint(x: buttonsX, y: mainFrame.maxY - imageWidth * 1.4), size: imageSize)
        protectButton.imageView?.contentMode = .scaleAspectFit
        petButton.imageView?.contentMode = .scaleAspectFit
        protectButton.layer.addBlackShadow(3)
        petButton.layer.addBlackShadow(3)
        
        protectButton.addTarget(self, action: #selector(humanButtonTouched), for: .touchUpInside)
        petButton.addTarget(self, action: #selector(petButtonTouched), for: .touchUpInside)
        
        // image view
        let bottomImageView = UIImageView(frame: CGRect(x: bottomHMargin, y: mainFrame.maxY - gap, width: width - bottomHMargin * 2, height: gap * 0.9))
        bottomImageView.contentMode = .scaleAspectFit
        bottomImageView.image = UIImage(named: "Slow Aging By Design")
       
        // add
        view.addSubview(titleLabel)
        view.addSubview(arcButtons)
        view.addSubview(detailDraw)

        view.addSubview(bottomImageView)
        view.addSubview(landing)
        
        view.addSubview(protectButton)
        view.addSubview(petButton)
        
        arcButtons.setDisplayState(true)
        detailDraw.isUserInteractionEnabled = false
        
        // animation
        let selectedIndex = landing.indexForRiskClass(selectedRiskClass)
        landing.focusOnTire(tireIndex, selectionIndex: selectedIndex)
    }
    
    fileprivate func createBarButtons() {
        // spacer
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        spacer.width = -10
        
        // backButton
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 13 * standWP, height: 22 * standWP)
        backButton.setBackgroundImage(UIImage(named: "barButton_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems = [spacer, UIBarButtonItem(customView: backButton)]
    }

    // ACTIONS
    func backButtonClicked() {
        if navigationController!.viewControllers.count > 1 {
            navigationController!.popViewController(animated: true)
        }else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func humanButtonTouched() {
        let readinessVC = ReadiniessViewController()
        navigationController?.pushViewController(readinessVC, animated: true)
    }
    
    func petButtonTouched() {
        if UserCenter.sharedCenter.userState != .login {
            let loginVC = LoginViewController()
            loginVC.modeForShowingLoginVc = .showPet
            loginVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(loginVC, animated: true)
        }else {
           
        }
    }
    
    // button
    func goToGames(_ button: CustomButton) {
        RiskMetricCardsCursor.sharedCursor.riskTypeKey = button.key
        RiskTypeDisplayModel.sharedRiskType.setupWithKey(button.key)
        GameTintApplication.sharedTint.gameTopic = .normal // .blueZone

        let introPageVC = IntroPageViewController()
        navigationController?.pushViewController(introPageVC, animated: true)
    }

    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "Home"
    }
}
