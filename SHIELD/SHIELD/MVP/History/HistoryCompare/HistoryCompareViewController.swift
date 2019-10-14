//
//  HistoryCompareViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/29.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class HistoryCompareViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var leftArrow: UIButton!
    @IBOutlet weak var rightArrow: UIButton!
    fileprivate let compareWhatView = HistoryWhatCompareView()
    fileprivate let compareWhyView = HistoryWhyCompareView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Compare"
        
        compareWhatView.layer.addBlackShadow(4 * fontFactor)
        compareWhyView.layer.addBlackShadow(4 * fontFactor)
        scrollView.addSubview(compareWhatView)
        scrollView.addSubview(compareWhyView)
        leftArrow.isHidden = true
        scrollView.isScrollEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let scrollFrame = scrollView.bounds
        scrollView.contentSize = CGSize(width: scrollFrame.width * 2, height: scrollFrame.height)
        compareWhatView.frame = scrollFrame.insetBy(dx: 10 * fontFactor, dy: 5 * fontFactor)
        compareWhyView.frame = CGRect(center: CGPoint(x: scrollFrame.width * 1.5, y: scrollFrame.midY), width: compareWhatView.frame.width, height: compareWhatView.frame.height)
        
    }
    
    func setupWithFirstMeasurement(_ first: MeasurementObjModel, second: MeasurementObjModel) {
        var measurements = [first, second]
        measurements.sort(by: { $0.timeString! < $1.timeString! })
        
        compareWhatView.setupWithLeft(measurements.first!, right: measurements.last!)
        compareWhyView.setupWithLeft(measurements.first!, right: measurements.last!)
    }
    
    @IBAction func goToLast(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }) { (true) in
            self.leftArrow.isHidden = true
            self.rightArrow.isHidden = false
        }
        
    }
    
    
    @IBAction func goToNext(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.contentOffset = CGPoint(x: width, y: 0)
        }) { (true) in
            self.leftArrow.isHidden = false
            self.rightArrow.isHidden = true
        }
    }
    
}
