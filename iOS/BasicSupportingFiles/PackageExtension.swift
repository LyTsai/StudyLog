//
//  PackageExtension.swift
//  DemystiPhi
//
//  Created by L on 2020/3/27.
//  Copyright © 2020 MingHui. All rights reserved.
//

import Foundation
import SDWebImage

// MARK: --------- imageView
extension UIImageView {
    func loadWebImage(_ imageUrl: URL?, completion: (()->Void)?) {
        // load
        loadWebImage(imageUrl, placeHolder: nil, completion: completion)
    }
    
    func loadWebImage(_ imageUrl: URL?, placeHolder: UIImage?, completion: (()->Void)?) {
        // load
        sd_setImage(with: imageUrl, placeholderImage: placeHolder != nil ? placeHolder : UIImage.animatedImageNamed("loading_0", duration: 1), options: .refreshCached) { (image, error, _, _) in
            // change frame
            if image != nil {
                // success
                let transition = CATransition()
                transition.duration = 0.3
                transition.type = .fade
                transition.isRemovedOnCompletion = true
                self.layer.add(transition, forKey: "transition")
                
                // image is replaced
                completion?()
            }
            
            if error != nil {
                print("fetch image error: \(error!.localizedDescription)")
            }
        }
        
        layer.removeAnimation(forKey: "transition")
    }
}


