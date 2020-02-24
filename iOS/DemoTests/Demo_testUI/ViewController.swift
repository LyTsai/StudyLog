//
//  ViewController.swift
//  Demo_testUI
//
//  Created by iMac on 17/3/31.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    let imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        let scroll = UIScrollView(frame: CGRect(x: 0, y: 100, width: 300, height: 100))
        scroll.contentSize = CGSize(width: 300, height: 500)
        let sub = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
        sub.text = "a quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\na quick brown fox jumps over the lazy dog\n"
        sub.numberOfLines = 0
        sub.font = UIFont.systemFont(ofSize: 16 * minOnePoint, weight: .black)
        scroll.addSubview(sub)
        
        imageView.contentMode = .scaleAspectFit
        scroll.backgroundColor = UIColor.green
        imageView.backgroundColor = UIColor.red
        imageView.frame = CGRect(x: 320, y: 100, width: 300, height: 300)
        view.addSubview(imageView)
        view.addSubview(scroll)
        
        imageView.image = UIImage.imageFromView(scroll)
    }
  

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
}
