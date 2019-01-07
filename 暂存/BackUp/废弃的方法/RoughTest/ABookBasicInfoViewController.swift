//
//  ABookRoughRiskTestViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/19.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import UIKit
class ABookBasicInfoViewController: ABookTwoButtonsViewController, UITableViewDataSource, UITableViewDelegate {
    let tableView = UITableView()
    var leftTexts = ["Gender", "Age", "My Health", "My Lifestyle"]
    var rightViews = [UIView]()
    var proportion: CGFloat = 0.25
    
    /** result turple */
    var testResult = (isMale: true, age: 50, health: 0.5, lifeStyle: 0.5)
    // TODO: as the data changes, the chart is redrawn
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        navigationItem.title = "My Basic Info"
        buttonTitles = ["My Risk Socres","Stories & Stats"]

        setupButtons()
        
        // tableView
        addRightViews()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: topLayoutGuide.length, width: width, height: button1.frame.minY - topLayoutGuide.length - buttonMargin)
        tableView.setNeedsDisplay()
    }
    
    fileprivate func addRightViews(){

        let genderView = GenderSwitch()
        rightViews.append(genderView)
        
        let ageView = AgeSlider()
//        ageView.sliderFrame = CGRect(x: 40, y: 40, width: 200, height: 30)
        ageView.setUpSilder()
        
        let ageView1 = AgeSlider()
//        ageView1.sliderFrame = CGRect(x: 40, y: 40, width: 200, height: 30)
        ageView1.setUpSilder()
        
        let ageView2 = AgeSlider()
//        ageView2.sliderFrame = CGRect(x: 40, y: 40, width: 200, height: 30)
        ageView2.setUpSilder()
        
        rightViews.append(ageView)
        rightViews.append(ageView1)
        rightViews.append(ageView2)
    }
    
    // MARK: ---------- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return leftTexts.count
        default:
            return 1
        }
    }

    let riskTestIdentifier = "RiskTest"
    let riskChartIdentifier = "RiskChart"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let riskTestcell = RiskTestTableViewCell.cellWithTableView(tableView, reuseIdentifier: riskTestIdentifier, leftText: leftTexts[indexPath.row], rightView: rightViews[indexPath.row])
            riskTestcell.setLayoutWithProportion(proportion)
            return riskTestcell
        default:
            let chartView = MHLineChartView(frame:CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 220)))
            var chartViewCell = tableView.dequeueReusableCell(withIdentifier: riskChartIdentifier)
            if chartViewCell == nil {
                chartViewCell = ResultChartViewCell(style: .default, reuseIdentifier: riskChartIdentifier)
                chartViewCell!.selectionStyle = .none
                chartViewCell!.contentView.addSubview(chartView)
            }
            chartView.reloadData()
            return chartViewCell!
        }
    }
    
    // MARK: ------------- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        default:
            return 220
        }
    }

}
