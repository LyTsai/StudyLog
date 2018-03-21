//
//  IntroPlayStateCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/14.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let introPlayStateCellID = "intro play state cell ID"
class IntroPlayStateCell: UITableViewCell {
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var riskNameLabel: UILabel!
    @IBOutlet weak var answerInfoLabel: UILabel!
    @IBOutlet weak var processView: CustomProcessView!

    @IBOutlet weak var processImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    // delegate
    weak var hostTable: IntroPageTableView!

    // create

    class func cellWithTableView(_ tableView: UITableView, imageUrl: URL?, riskName: String?, answerInfo: String?, answered: Int, total: Int) -> IntroPlayStateCell {
        let allAnsweredText = "You have finished this game. You can move to other risk assessment or other algorithms."
        let partAnsweredText = "You have not finished this game yet. You can continue or try other games."
        
        var cell = tableView.dequeueReusableCell(withIdentifier: introPlayStateCellID) as? IntroPlayStateCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("IntroPageCells", owner: self, options: nil)?[1] as? IntroPlayStateCell
            cell?.updateUI()
        }
        
        // image
        cell!.cardImageView.sd_setShowActivityIndicatorView(true)
        cell!.cardImageView.sd_setIndicatorStyle(.gray)
        cell!.cardImageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached, progress: nil) { (image, error, type, url) in
            if image == nil {
                cell!.cardImageView.image = ProjectImages.sharedImage.placeHolder
            }
        }
        // text
        cell!.riskNameLabel.text = riskName
        cell?.answerInfoLabel.text = answerInfo
        
        // info
        cell?.processView.processVaule = CGFloat(answered) / CGFloat(total)
        cell?.processImageView.isHidden = (answered != total)
        cell?.descriptionLabel.text = (answered == total) ? allAnsweredText : partAnsweredText
        
        return cell!
    }
    
    fileprivate func updateUI() {
        selectionStyle = .none
        
        processView.processColor = UIColorFromRGB(126, green:  211, blue:33)
        processView.layer.masksToBounds = true
        
        playButton.layer.borderWidth = fontFactor
        playButton.layer.borderColor = UIColorFromRGB(153, green: 154, blue: 170).cgColor
        
        riskNameLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: UIFontWeightMedium)
        answerInfoLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: UIFontWeightMedium)
        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: UIFontWeightMedium)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        processView.layer.cornerRadius = processView.bounds.height * 0.5
        playButton.layer.cornerRadius = playButton.bounds.height * 0.5
    }

    
    // action
    @IBAction func playAgain(_ sender: Any) {

        if UserCenter.sharedCenter.userState != .none {
//            UserCenter.sharedCenter.setLoginUserAsTarget()
            // logged or default
            let navi = hostTable.hostNavi!
            let riskAssess =  CategoryViewController()
//            ABookRiskAssessmentViewController()
            navi.pushViewController(riskAssess, animated: true)
        }
    }
    
}
