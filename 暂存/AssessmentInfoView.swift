//
//  AssessmentInfoView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/6.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

class UserInfoView: UIView {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userGenderImageView: UIImageView!
    
    @IBOutlet weak var userAgeLabel: UILabel!
    
    fileprivate let femaleImage = UIImage()
    fileprivate let notToldImage = UIImage()
    
    // user or pseudouser
    // get the login user as the default user
    var userInfo: UserInfoModel! {
        didSet{
            if userInfo !== oldValue {
                fillDataWithUserInfo(userInfo)
            }
        }
    }
    
    class func createUserInfoViewWithUserInfo(_ userInfo: UserInfoModel) -> UserInfoView{
        let userInfoView = Bundle.main.loadNibNamed("AssessmentInfoView", owner: self, options: nil)?.first as! UserInfoView
        userInfoView.fillDataWithUserInfo(userInfo)
        userInfoView.modifyUI()
        
        return userInfoView
    }
    
    fileprivate func fillDataWithUserInfo(_ userInfo: UserInfoModel) {
        userImageView.image = convertDataObjectToImage(userInfo.image) ?? UIImage(named: "userIcon")! // add a default image here incase the image did not exist

        userNameLabel.text = (userInfo.name == "" ? "Not Told" : userInfo.name)
        userAgeLabel.text = "\(userInfo.age)"
        
        var genderImage = UIImage()
        let gender = userInfo.sex
        
        if gender?.caseInsensitiveCompare("female") == .orderedSame {
            genderImage = UIImage(named: "gender_female")!
        }else if gender?.caseInsensitiveCompare("male") == .orderedSame {
            genderImage = UIImage(named: "gender_male")!
        }else {
           // genderImage = UIImage(named: "gender_unknown")!
        }
        userGenderImageView.image = genderImage
    }
    fileprivate func modifyUI()  {
        backgroundColor = unselectedCellBackColor
        userAgeLabel.backgroundColor = UIColor.white
//        userAgeLabel.layer.borderWidth = 0.5
//        userAgeLabel.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
//        userAgeLabel.layer.cornerRadius = 3
    }
}

// used for risk model selection of risk class
class AuthorSelectView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var authorInfoLabel: UILabel!
    
    // risk class
    var riskClass = MetricModel() {
        didSet{
            if riskClass != oldValue {
//                imageView.image = riskClass.image?.realImage
            }
        }
    }
    
    // risk model (class instance)
    var riskModel = RiskModel() {
        didSet{
            if riskModel != oldValue {
                // new value
            }
        }

    }
    
    class func createAuthorSelectViewWithRisk(_ riskClass: MetricModel, riskModel: RiskModel) -> AuthorSelectView {
        let authorSelectView = Bundle.main.loadNibNamed("AssessmentInfoView", owner: self, options: nil)?.last as! AuthorSelectView
        authorSelectView.riskClass = riskClass
        authorSelectView.riskModel = riskModel
        authorSelectView.modifyUI()
        
        return authorSelectView
    }
    
    let barLayer = CALayer()
    fileprivate var selectionIndicator = CAShapeLayer()
    func modifyUI()  {
//        backgroundColor = selectedCellBackColor
        let image = UIImage(named: "icon_risk_VD")!
        imageView.image = image.imageWithColor(selectedCellBackColor)
        
        detailLabel.backgroundColor = UIColor.white
        detailLabel.layer.cornerRadius = 3
        detailLabel.layer.masksToBounds = true
        
        barLayer.backgroundColor = UIColorFromRGB(65, green: 117, blue: 5).cgColor
        layer.addSublayer(barLayer)
        
        selectionIndicator.fillColor = UIColor.white.cgColor
        barLayer.addSublayer(selectionIndicator)
    }
    
    func setupInidcator(_ arrowUp: Bool){
        let path = UIBezierPath()
        if arrowUp {
            path.move(to: CGPoint(x: bounds.midX, y: 1))
            path.addLine(to: CGPoint(x: bounds.midX + 4, y: 5))
            path.addLine(to: CGPoint(x: bounds.midX - 4, y: 5))
            path.close()
        }else {
            path.move(to: CGPoint(x: bounds.midX, y: 5))
            path.addLine(to: CGPoint(x: bounds.midX + 4, y: 1))
            path.addLine(to: CGPoint(x: bounds.midX - 4, y: 1))
            path.close()
        }
        selectionIndicator.path = path.cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let barHeight: CGFloat = 6
        barLayer.frame = CGRect(x: 0, y: bounds.height - barHeight, width: bounds.width, height: barHeight)
        setupInidcator(true)
    }
}

class NodeView: UIView {
    var labelText = "Why Should I Care?" {
        didSet{
            textLabel.text = labelText
        }
    }
    
    fileprivate var textLabel = UILabel()
    var labelPro: CGFloat = 0.26
    
    class func createNodeViewWithFrame(_ frame: CGRect) -> NodeView {
        let nodeView = NodeView(frame: frame)
        nodeView.backgroundColor = unselectedCellBackColor
        
        let labelWidth = nodeView.labelPro * frame.width
        let labelFrame = CGRect(x: labelWidth * 0.2, y: 0, width: labelWidth, height: frame.height * 0.5)
        let nodeFrame = CGRect(x: labelWidth * 0.5 , y: 0, width: frame.width - labelFrame.midX, height: frame.height)

        let nodeGraph = ANNodeGraph(frame: nodeFrame)
        nodeGraph.backgroundColor = UIColor.clear
        nodeGraph.loadTestNodeTree_New()

        nodeView.textLabel.text = nodeView.labelText
        nodeView.textLabel.frame = labelFrame
        nodeView.textLabel.numberOfLines = 0
        nodeView.textLabel.font = UIFont.systemFont(ofSize: 6)
        nodeView.textLabel.backgroundColor = UIColor.clear

        nodeView.addSubview(nodeGraph)
        nodeView.addSubview(nodeView.textLabel)
    
        return nodeView
    }
    
}
