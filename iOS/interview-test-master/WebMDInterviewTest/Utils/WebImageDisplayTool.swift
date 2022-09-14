//
//  WebImageDisplayTool.swift
//  WebMDInterviewTest
//
//  Created by Lydire Tsai on 2022/9/14.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func loadWebImage(_ imageUrl: URL?) {
        self.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""), options: .forceTransition, progress: nil, completed: nil)
    }
}
