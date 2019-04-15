//
//  FamilyTreeViewController.swift
//  AnnielyticX
//
//  Created by Lydire on 2018/5/29.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class SingleUserView: UIView {
    let iconView = UIImageView()
    let nameLabel = UILabel()
    var ratio: CGFloat = 0.7
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
        
    }
    
    fileprivate func setWithName(_ name: String!, imageUrl: URL!) {
        nameLabel.text  = name
        iconView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "userIcon"), options: .refreshCached, progress: nil, completed: nil)
    }
    
    fileprivate func setupBasic() {
        addSubview(iconView)
        addSubview(nameLabel)
        
        iconView.layer.masksToBounds = true
        iconView.contentMode = .scaleAspectFit
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let iconL = min(bounds.height, bounds.height) * ratio
        iconView.frame = CGRect(x: bounds.midX - iconL * 0.5, y: 0, width: iconL, height: iconL)
        iconView.layer.cornerRadius = iconL * 0.5
        nameLabel.frame = CGRect(x: 0, y: iconL, width: bounds.width, height: bounds.height - iconL)
        nameLabel.font = UIFont.systemFont(ofSize: nameLabel.frame.height * 0.4, weight: UIFont.Weight.medium)
    }
}



class FamilyTreeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Family Tree Map"
        view.backgroundColor = UIColor.white
        
        
        let user = UserCenter.sharedCenter.loginUserObj
        let pesudo = userCenter.pseudoUsers
        
        let centerFrame = mainFrame.insetBy(dx: 0, dy: (mainFrame.height - mainFrame.width) * 0.5)
        let viewCenter = CGPoint(x: mainFrame.midX, y: mainFrame.midY)
        
        let subL = centerFrame.width * 0.25
        
        let radius = centerFrame.midX - subL * 0.6
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(center: viewCenter, length: radius * 2)).cgPath
        shapeLayer.lineWidth = 2 * fontFactor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = tabTintGreen.cgColor
        view.layer.addSublayer(shapeLayer)
        
        let userView = SingleUserView(frame: CGRect(center: viewCenter, length: subL))
        userView.setWithName(user.displayName, imageUrl: nil)
        view.addSubview(userView)
        
        var pesudoViews = [SingleUserView]()
        for pesudo in pesudo {
            let pesudoView = SingleUserView()
            pesudoView.setWithName(pesudo.name, imageUrl: nil)
            view.addSubview(pesudoView)
            pesudoViews.append(pesudoView)
        }
        
        ButterflyLayout.layoutEvenCircleWithRootCenter(viewCenter, children: pesudoViews, radius: radius, startAngle: 0, expectedLength: subL)
        
        
    }
}
