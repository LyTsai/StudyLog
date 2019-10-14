//
//  ProjectImages.swift
//  AnnielyticX
//
//  Created by L on 2019/6/10.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation
class ProjectImages {
    static let sharedImage = ProjectImages()
    
    // place holder
    let imagePlaceHolder = UIImage(named: "cache-image")
    let indicator = UIImage(named: "cache-image")
    
    let tempAvatar = UIImage(named: "avatar_temp")
    
    // back
    let landingBack = UIImage(named: "landingPageBack")
    let backImage = UIImage(named: "homeBackImage")
    
    let playCardsBackV = UIImage(named: "playCards_back_virtual")
    let categoryBack = UIImage(named: "category_back")
    let categoryBackV = UIImage(named: "category_back_virtual")
    
    // card images
    let cardSide = UIImage(named: "card_side")
    
    // multipleChoose
    var mulitpleLast: UIImage! {
        return WHATIF ? #imageLiteral(resourceName: "multiple_last_whatIf") : UIImage(named: "multiple_last")
    }
    let mulitpleLastDisabled = UIImage(named: "multiple_last_disabled")
    var mulitpleNext: UIImage! {
        return WHATIF ?  #imageLiteral(resourceName: "multiple_next_ whatIf") : UIImage(named: "multiple_next")
    }
    
    let mulitpleNextDisabled = UIImage(named: "multiple_next_disabled")
    
    // dismiss
    let circleCrossDismiss = UIImage(named: "button_dismiss")
    let rectCrossDismiss = UIImage(named: "riskTypes_dismiss")
    let grayCircleDismiss = UIImage(named: "dismissGray")
    let whiteCircleDismiss = UIImage(named: "dismiss_white")
    
    
    // check marks
    let roundCheck = UIImage(named: "check_greenWhite")
    let fullCheck = UIImage(named: "fullCheck")
    
    // category
    let roadCardTitle = UIImage(named: "road_card_title")
    let roadCardTitleV = UIImage(named: "road_card_title_virtual")
    let roadStart = UIImage(named: "road_start")
    let roadFlag = UIImage(named: "road_flag")
    // see how
}
