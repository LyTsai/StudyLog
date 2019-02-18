//
//  VitaminDCurrentLevelChooseView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/16.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VitaminDCurrentLevelChooseView: UIView {
    weak var host: VitaminDRefrenceView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var optionLabels: [UILabel]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadBasic()
    }
    
    fileprivate var view: UIView!
    fileprivate func loadBasic() {
        view = Bundle.main.loadNibNamed(String(describing: VitaminDCurrentLevelChooseView.self), owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        view.frame = bounds
        view.layoutSubviews()
        setupFonts(bounds.width / 345)
    }
    
    
    fileprivate func setupFonts(_ factor: CGFloat) {
        titleLabel.font = UIFont.systemFont(ofSize: 14 * factor, weight: UIFontWeightMedium)
        for label in optionLabels {
            label.font = UIFont.systemFont(ofSize: 11 * factor, weight: UIFontWeightMedium)
        }
    }
    

    
    @IBAction func optionIsChosen(_ sender: UIButton) {
        let index = sender.tag - 100
        host.optionIsChosen(index)
    }
    
    
}
