//
//  VisualMapCustomView.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/1/24.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
enum ButterflyMapState {
    case showHelps, showRiskTypes, showRiskClasses, showCards
}

enum ButterflyViewMode {
    case fromRiskClass, fromRiskType
}


class VisualMapCustomView: UIView {
    weak var hostVC: UIViewController!
    
    let avatar = UIImageView(image: UIImage(named: "avatar_act"))
    
    var helpNodes = [SimpleNode]()           // tag: 100 + i
    var riskClassNodes = [ButterflyNode]()   // riskClass.key
    var riskTypeNodes = [ButterflyNode]()    // riskType.key
    
    // user info
    var userKey: String {
        return userCenter.currentGameTargetUser.Key()
    }
    
    // colors for cardNodes
    var chosenHelpIndex: Int! {
        didSet{
            if chosenHelpIndex == 0 {
                // tier 1
                chosenRiskTypeKey = iCaKey
            }else if chosenHelpIndex == 1 {
                // tier 2
                chosenRiskTypeKey = iPaKey
            }
        }
    }
    var chosenRiskClassKey: String!
    var chosenRiskClassIndex: Int! { // for layout's benifit
        if chosenRiskClassKey != nil {
            for (i, node) in riskClassNodes.enumerated() {
                if chosenRiskClassKey == node.key {
                    return i
                }
            }
        }
        return nil
    }
    
    var chosenRiskTypeKey: String!
    var chosenRiskTypeIndex: Int! { // for layout's benifit
        if chosenRiskTypeKey != nil {
            for (i, node) in riskTypeNodes.enumerated() {
                if chosenRiskTypeKey == node.key {
                    return i
                }
            }
        }
        return nil
    }
    
    var chosenCardKey: String!
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = UIColor.clear
    }
    
    // create
    // helps
    func createHelpNodes(_ withDeco: Bool, nodeFrame: CGRect, decoSize: CGSize) {
        // tier 1, 2, 3
        let helpTexts = ["Help You Care", "Help You Understand", "Help You Act"]
        for (i, text) in helpTexts.enumerated() {
            let help = SimpleNode()
            help.text = text
            help.borderShape = .diamond
            help.frame = nodeFrame
            help.tag = 100 + i
            
            addSubview(help)
            helpNodes.append(help)
            
            // deco
            if withDeco {
                let deco = UIImageView(image: ProjectImages.sharedImage.butterfly)
                help.decoView = deco
                deco.transform = CGAffineTransform.identity
                deco.frame = CGRect(center: CGPoint(x: nodeFrame.midX, y: nodeFrame.midY), width: decoSize.width, height: decoSize.height)
                insertSubview(deco, belowSubview: help)
            }
        }
    }
    
    // riskTypes
    func createRiskTypeNodes() {
        let riskTypes = collection.getAllRiskTypes()
        for riskType in riskTypes {
            if riskType.key == iCaKey || riskType.key == iPaKey {
                continue
            }
            
            let node = ButterflyNode()
            node.key = riskType.key
            
            // colors are dynamic
            riskTypeNodes.append(node)
            addSubview(node)
        }
    }
    
    
    // alert
    func showAlert()  {
        let alert = UIAlertController(title: "No Record For This Node", message: "Would you like to play this deck of cards", preferredStyle: .alert)
        let playAction = UIAlertAction(title: "Play", style: .default) { (true) in
        self.goToLanding()
        }
        let action = UIAlertAction(title: "Later", style: .default, handler: nil)
        alert.addAction(playAction)
        alert.addAction(action)
        hostVC.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func goToLanding() {
        if self.chosenRiskClassKey != nil {
            cardsCursor.selectedRiskClassKey = chosenRiskClassKey
            let tab = hostVC.tabBarController
            //            tab?.selectedIndex = 1
            let navi = tab!.viewControllers![0] as! ABookNavigationController
            for vc in navi.viewControllers {
                if vc.isKind(of: ABookLandingPageViewController.self) {
                    navi.popToViewController(vc, animated: true)
                    break
                }
            }
        }
        
        GameTintApplication.sharedTint.focusingTierIndex = chosenHelpIndex
        let landing = ABookLandingPageViewController()
        self.hostVC.navigationController?.pushViewController(landing, animated: true)
    }
    
}
