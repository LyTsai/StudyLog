//
//  UserDisplayView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/1/19.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class UserDisplayView: UIView {
    
    fileprivate var userDetail: UIView!
    fileprivate var detailOnShow = false
    let defaultSize = CGSize(width: 176, height: 35)
    fileprivate let forMoreImageView = UIImageView(image: UIImage(named: "icon_forDetail"))
    
    fileprivate var detailHeight: CGFloat {
        return 0.714 * bounds.height
    }
    fileprivate var detailWidth: CGFloat {
        return bounds.width - bounds.height / 2
    }
    
    class func createWithFrame(_ frame: CGRect, userInfo: UserinfoObjModel) -> UserDisplayView {
        let displayView = UserDisplayView()
        displayView.setupWithFrame(frame, userInfo: userInfo)
        
        return displayView
    }
    
    // update UI
    fileprivate var genderImageView = UIImageView()
    fileprivate var infoLabel = UILabel()
    fileprivate var userIcon = UIImageView()
    fileprivate func setupWithFrame(_ frame: CGRect, userInfo: UserinfoObjModel) {
        self.frame = frame
        
        let halfHeight = frame.height / 2
        // icon: 35 * 35
        userIcon = UIImageView(frame: CGRect(center: CGPoint(x: halfHeight, y: halfHeight), length: frame.height))
        userIcon.layer.cornerRadius = halfHeight
        userIcon.layer.borderColor = UIColor.lightGray.cgColor
        userIcon.layer.borderWidth = 1
        userIcon.layer.masksToBounds = true
        userIcon.isUserInteractionEnabled = true
        
        // indi: 6 * 9
        let forMoreHeight = frame.height * 9 / 35
        forMoreImageView.frame = CGRect(x: frame.height + 1, y: halfHeight - forMoreHeight * 0.5, width: forMoreHeight * 6 / 9, height: forMoreHeight)
        
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(changeUserDetailState))
        userIcon.addGestureRecognizer(tapGR)
        
        // user detail
        let maskView = UIView(frame: CGRect(x: halfHeight, y: halfHeight - detailHeight / 2, width: detailWidth, height: detailHeight))
        maskView.clipsToBounds = true
        
        userDetail = UIView(frame: CGRect(x:  -detailWidth, y: 0, width: detailWidth, height: detailHeight))
        userDetail.backgroundColor = UIColor.white
        userDetail.layer.borderColor = UIColor.darkGray.cgColor
        userDetail.layer.borderWidth = 1
        userDetail.layer.cornerRadius = detailHeight / 2

        maskView.addSubview(userDetail)
        
        infoLabel.frame = CGRect(x: 0 , y: 0, width: detailWidth * 0.766, height: detailHeight)
        infoLabel.textAlignment = .right

        infoLabel.font = UIFont.boldSystemFont(ofSize: detailHeight / 2.5)
        userDetail.addSubview(infoLabel)
        
        let genderWidth = 0.35 * detailHeight
        genderImageView.frame = CGRect(x: detailWidth * 0.8 , y: (detailHeight - genderWidth) / 2, width: genderWidth, height: genderWidth)

        userDetail.addSubview(genderImageView)

        // overlapped
        addSubview(forMoreImageView)
        
        addSubview(maskView)
        addSubview(userIcon)
        
        fillUserInfoData(userInfo)
    }
    
    func fillUserInfoData(_ userInfo: UserinfoObjModel)  {
        userIcon.image = userInfo.imageObj ?? UIImage(named: "userIcon")
        let name = userInfo.name ?? "Not Given"
        let age = CalendarCenter.getAgeFromDateOfBirthString(userInfo.dobString)
        infoLabel.text = "\(name) | Age: \(age)"  // <- Lisa: convert o age
       
        var genderImage = UIImage()
        let gender = userInfo.sex
        
        if gender?.caseInsensitiveCompare("female") == .orderedSame {
            genderImage = UIImage(named: "gender_female")!
        }else if gender?.caseInsensitiveCompare("male") == .orderedSame {
            genderImage = UIImage(named: "gender_male")!
        }else {
            genderImage = UIImage(named: "gender_male")!
            // genderImage = UIImage(named: "gender_unknown")!
        }
        genderImageView.image = genderImage
    }
    
    @objc func changeUserDetailState() {
        UIView.animate(withDuration: 0.4, delay: 0, options: (detailOnShow ? .curveEaseOut : .curveEaseIn), animations: {
            self.userDetail.frame.origin.x = (self.detailOnShow ? -self.detailWidth : 0)
        }, completion: nil)
    
        detailOnShow = !detailOnShow
    }
}
