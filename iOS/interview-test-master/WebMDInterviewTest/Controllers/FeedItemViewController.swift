//
//  FeedItemViewController.swift
//  WebMDInterviewTest
//
//  Created by L on 2022/9/14.
//

import Foundation
import UIKit

class FeedItemViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupWithFeedItem(_ feedItem: FeedItem) {
        navigationItem.title = feedItem.title
        
    }
}
