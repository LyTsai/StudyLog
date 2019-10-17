//
//  IntroductionViewController.swift
//  SHIELD
//
//  Created by Lydire on 2019/9/20.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class IntroductionViewController: WebViewViewController {
    override var url: URL! {
        return URL(string: "\(pagesBaseUrl)public/CognoTanzi/")
    }
}
