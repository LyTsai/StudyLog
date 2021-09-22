//
//  AlertMessageDisplayTool.swift
//  MagniPhi
//
//  Created by L on 2021/7/2.
//  Copyright © 2021 MingHui. All rights reserved.
//

import Foundation
import UIKit

class AlertMessageDisplayTool {
    var onDisplay: Bool {
        return backView.superview != nil
    }
    
    static let displayTool = AlertMessageDisplayTool()
    
    fileprivate let dismissButton = UIButton(type: .custom)
    fileprivate let imageView = UIImageView()
    fileprivate let backView = UIView()
    fileprivate let titleLabel = UILabel()
    fileprivate let displayBackView = UIView()
    
    fileprivate var actionButtons = [GradientButton]()
    init() {
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        displayBackView.backgroundColor = UIColor.white
        
        dismissButton.setBackgroundImage(UIImage(named: "icon_dismiss_gray"), for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        // add
        backView.addSubview(displayBackView)
        displayBackView.addSubview(imageView)
        displayBackView.addSubview(dismissButton)
        displayBackView.addSubview(titleLabel)
        
        displayBackView.layer.addBlackShadow(12)
        
        layoutViews()
    }
    
    fileprivate var onePoint: CGFloat {
        let displayLength = min(max(width, height) * 0.39, min(height, width) * 0.52)
        return displayLength / 400
    }
    fileprivate func layoutViews() {
        backView.frame = UIScreen.main.bounds
        let displayL = 400 * onePoint
        displayBackView.frame = CGRect(center: CGPoint(x: width * 0.5, y: height * 0.5), length: displayL)
        displayBackView.layer.cornerRadius = 12 * onePoint
        
        let buttonL = 32 * onePoint
        let buttonM = 16 * onePoint
        dismissButton.frame = CGRect(x: displayL - buttonM - buttonL, y: buttonM, width: buttonL, height: buttonL)
        imageView.frame = CGRect(x: displayL * 0.5 - 50 * onePoint, y: dismissButton.frame.maxY, width: 100 * onePoint, height: 120 * onePoint)
    }
    
    fileprivate func layoutButtons() {
        let displayL = displayBackView.frame.width
        // title
        let buttonY = displayL - 75 * onePoint
        titleLabel.frame = CGRect(x: 0, y: imageView.frame.maxY, width: displayL, height: buttonY - imageView.frame.maxY).insetBy(dx: 25 * onePoint, dy: 5 * onePoint)
        // button
        let buttonSize = CGSize(width: 160 * onePoint, height: 40 * onePoint)
        if actionButtons.count == 1 {
            actionButtons[0].frame = CGRect(origin: CGPoint(x: displayL * 0.5 - buttonSize.width * 0.5, y: buttonY), size: buttonSize)
        }else if actionButtons.count == 2 {
            let buttonGap = 8 * onePoint
            let buttonX = (displayL - buttonGap - 2 * buttonSize.width) * 0.5
            for (i, button) in actionButtons.enumerated() {
                button.frame = CGRect(origin: CGPoint(x: buttonX + CGFloat(i) * (buttonGap + buttonSize.width), y: buttonY), size: buttonSize)
            }
        }
    }

    @objc func dismissPage() {
        backView.removeFromSuperview()
    }
    
    // setup
    func showAlertWithIcon(_ icon: UIImage?, message : String?, title : String?, buttons: [(name: String, selected: Bool, handle: (()->Void)?)]) {
        
        if onDisplay {
            // some on display now
            return
        }
        
        imageView.image = icon ?? UIImage(named: "alert_default")
        
        // text
        let linePara = NSMutableParagraphStyle()
        linePara.lineSpacing = 5 * onePoint
        linePara.alignment = .center
        
        let attributedString = NSMutableAttributedString(string: title ?? "", attributes: [.font: UIFont.systemFont(ofSize: 18 * onePoint, weight: .semibold), .foregroundColor: UIColorFromHex(0x0D230F), .paragraphStyle: linePara])
        if message != nil {
            attributedString.append(NSAttributedString(string: "\n  ", attributes: [.font: UIFont.systemFont(ofSize: 15 * onePoint, weight: .semibold)]))
            
            attributedString.append(NSAttributedString(string: "\n\(message!)", attributes: [.font: UIFont.systemFont(ofSize: 16 * onePoint), .foregroundColor: UIColorFromHex(0x0D230F), .paragraphStyle: linePara]))
        }
        titleLabel.attributedText = attributedString
        
        // actions
        // clear current
        for button in actionButtons {
            button.removeFromSuperview()
        }
        
        actionButtons.removeAll()
        
        // setup
        for info in buttons {
            let button = GradientButton(type: .custom)
            button.setTitle(info.name)
            button.isSelected = info.selected
            button.addButtonAction {
                self.dismissPage()
                info.handle?()
            }
            
            displayBackView.addSubview(button)
            actionButtons.append(button)
        }
        
        layoutButtons()
        
        // display
        if backView.superview == nil {
            (UIApplication.shared.delegate as! AppDelegate).window?.addSubview(backView)
        }
    }
    
}
extension AlertMessageDisplayTool {
    class func showForLoginAndSignHintDisplay(_ message: String?, title: String?) {
        AlertMessageDisplayTool.displayTool.showAlertWithIcon(UIImage(named: "alert_basicInfo"), message: message, title: title, buttons: [("OK", true, nil)])
    }
    
    // upload
    class func showAlertForUploadFail(_ error: String?, retry: (() -> Void)?, viewController: UIViewController?) {
        if error != nil && error == "UNAUTHORIZED" {
            // need login
            AlertMessageDisplayTool.displayTool.showAlertWithIcon(UIImage(named: "alert_upload"), message: error, title: "Need To Login", buttons: [("Login", true, {
                userCenter.logOut()
                
                let login = LoginViewController.createFromNib()
                login.loginSuccess = {
                    login.dismiss(animated: true) {
                        retry?()
                    }
                }
                login.modalPresentationStyle = .fullScreen
                
                viewController?.present(login, animated: true, completion: nil)
            })])
        }else {
            AlertMessageDisplayTool.displayTool.showAlertWithIcon(UIImage(named: "alert_upload"), message: error, title: "Failed to upload", buttons: [("Upload Again", true, retry)])
        }
    }
    
    // down load
    class func showAlertForDownloadFail(_ topic: String?, error: String?, retry: (() -> Void)?, ignore: (() -> Void)?, viewController: UIViewController?) {
        if error != nil && error == "UNAUTHORIZED" && viewController != nil {
            // need login
            AlertMessageDisplayTool.displayTool.showAlertWithIcon(UIImage(named: "alert_upload"), message: error, title: "Need To Login", buttons: [("Login", true, {
                let login = LoginViewController.createFromNib()
                login.loginSuccess = {
                    login.dismiss(animated: true) {
                        retry?()
                    }
                }
                
                viewController?.present(login, animated: true, completion: nil)
            })])
        }else {
            var buttons = [("Reload", true, retry)]
            if ignore != nil {
                buttons.insert(("Ignore", false, ignore), at: 0)
            }
            AlertMessageDisplayTool.displayTool.showAlertWithIcon(UIImage(named: "alert_loadFail"), message: error, title: "Failed to Load \(topic ?? "")", buttons: buttons)
        }
    }

    class func showForUnavailableRisk(_ riskKey: String?) {
        let riskName = collection.getRisk(riskKey)?.name
        AlertMessageDisplayTool.displayTool.showAlertWithIcon(UIImage(named: "alert_basicInfo"), message: "Based on your \"basic\" info, this assessment is not suited for you.", title: "\(riskName ?? "Risk") Assessment", buttons: [("Close", true, nil)])
    }
}

