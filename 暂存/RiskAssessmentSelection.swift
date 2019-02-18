//
//  RiskAssessmentSelection.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/15.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

class AssessmentInfoView: UIView {
    weak var topAssessmentDelegate: AssessmentTopView!
    
    var currentIndex: Int = 0 {
        didSet{
            if currentIndex != oldValue {
                if authorSelectView != nil {
                }
            }
        }
    }
    
    // risk type (or class) such as CVD
    fileprivate var currentRiskClass: MetricModel!
    // specific model such as NIH model
    fileprivate var currentRiskModel: RiskModel!
    
    class func createWithFrame(_ frame: CGRect, riskClass: MetricModel, riskModel: RiskModel) -> AssessmentInfoView {
        let assessment = AssessmentInfoView(frame: frame)
        assessment.currentRiskClass = riskClass
        assessment.currentRiskModel = riskModel
        assessment.updateUI()
        
        return assessment
    }
    
    // selecting model target user
    var userInfoView: UserInfoView!
    var authorSelectView: AuthorSelectView!
    var nodeView: NodeView!
    
    var authorSelectWidth: CGFloat = 110
    var userInfoWidth: CGFloat {
        return (bounds.width - authorSelectWidth - gap) * 0.5
    }
    var gap: CGFloat = 1
    var tableMask = UIView()
    var userPullDown: UserPullDownTableView!
    var authorPullDown: AuthorPullDownTableView!
    
    let borderWidth: CGFloat = 1
    fileprivate func updateUI()  {
        backgroundColor = UIColor.lightGray

        // maskView, which is added in HeaderTop
        tableMask.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        tableMask.isHidden = true
        
        // add three views: userInfo, authorSelect, node
        addUserInfoView()
        addAuthorSelecteView()
        addNodeView()
    }
    
    // MARK: ---------- UserInfo
    fileprivate func addUserInfoView() {
 
        userInfoView = UserInfoView.createUserInfoViewWithUserInfo(UserCenter.sharedCenter.loginUserInfo)
        userInfoView.frame = CGRect(x: 0, y: 0, width: userInfoWidth, height: bounds.height)
        
        let userTap = UITapGestureRecognizer(target: self, action: #selector(selectUser))
        userInfoView.addGestureRecognizer(userTap)
        addSubview(userInfoView)
        
        // pull down
        let numberOnShow = min(UserCenter.sharedCenter.pseudoUsers.count + 1 , 4)
        userPullDown = UserPullDownTableView.createPullDownTableWithFrame(CGRect(x: 0, y: 0, width: userInfoWidth, height: CGFloat(numberOnShow) * bounds.height + 20), loginSelected: true)
        userPullDown.assessmentDelegate = self
        userPullDown.isHidden = true
        
        tableMask.addSubview(userPullDown)
    }
    
    func selectUser() {
        authorPullDown.isHidden = true
        userPullDown.isHidden = !userPullDown.isHidden
        tableMask.isHidden = userPullDown.isHidden
        
        // change data with currentUser, if the user is changed
        // userInfo
        
        // cards
    }
    
    // MARK: ---------- AuthorSelect
    fileprivate func addAuthorSelecteView() {
        authorSelectView = AuthorSelectView.createAuthorSelectViewWithRisk(currentRiskClass, riskModel:currentRiskModel)
        let authorSelectFrame = CGRect(x: userInfoWidth + gap, y: 0, width: authorSelectWidth, height: bounds.height)
        authorSelectView.frame = authorSelectFrame
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(selectRiskModelAuthor))
        authorSelectView.addGestureRecognizer(tapGR)
        
        addSubview(authorSelectView)
        
        // pull down
        let allRiskModels = AIDMetricCardsCollection.standardCollection.getRiskModels(currentRiskClass.key!)
        let rowOnShow = (allRiskModels.count >= 4 ? 4 : allRiskModels.count)
        let pullHeight = (bounds.height + borderWidth) * CGFloat(rowOnShow) + borderWidth
        
        authorPullDown = AuthorPullDownTableView.createPullDownTableWithFrame(CGRect(x: authorSelectView.frame.minX , y: 0, width: authorSelectWidth + 2 * borderWidth, height: pullHeight), riskClass: currentRiskClass, riskModels: allRiskModels)
        authorPullDown.assessmentDelegate = self
        authorPullDown.isHidden = true
        
        tableMask.addSubview(authorPullDown)
    }
    
    // for risk model author
    func selectRiskModelAuthor()  {
        userPullDown.isHidden = true
        authorPullDown.isHidden = !authorPullDown.isHidden
        authorSelectView.setupInidcator(authorPullDown.isHidden)
        tableMask.isHidden = authorPullDown.isHidden
    }
    
    // setup risk model selection for current risk class
    func updateWithRiskModel(_ riskModel: RiskModel)  {
        selectRiskModelAuthor()
        authorSelectView.riskModel = riskModel
    }
    
    func updateWithRiskClass(_ riskClass: MetricModel)  {
        authorSelectView.riskClass = riskClass
        tableMask.isHidden = true
    }

    // MARK: ---------- NodeView
    private func addNodeView(){
        let nodeFrame = CGRect(x: authorSelectView.frame.maxX + gap, y: 0, width: bounds.width - 2 * gap - authorSelectWidth - userInfoWidth, height: bounds.height)
        nodeView = NodeView.createNodeViewWithFrame(nodeFrame)
        addSubview(nodeView)
        
        // action for nodeView
        let goToSummaryGR = UITapGestureRecognizer(target: self, action: #selector(goToSummaryView))
        nodeView.addGestureRecognizer(goToSummaryGR)
    }
    
    func goToSummaryView()  {
        print("go to summary")
        topAssessmentDelegate.showTheSummary()
    }
    
}
