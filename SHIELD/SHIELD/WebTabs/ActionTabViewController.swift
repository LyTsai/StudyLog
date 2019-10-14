//
//  ActionTabViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2019/2/20.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation
import WebKit

class ActionTabViewController: WebViewViewController {
    override var url: URL! {
        return URL(string: "\(pagesBaseUrl)public/TabAction/")
    }
}
