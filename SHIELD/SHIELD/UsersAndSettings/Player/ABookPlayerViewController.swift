//
//  ABookPlayerViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/9/3.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ABookPlayerViewController: UIViewController {
    var currentUserIsChanged: (() -> ())?
    
    var leftOnShow = true {
        didSet{
            setupTopButtons()
        }
    }
    
    var backToIntroAfterChoose = false
    
    @IBOutlet weak var leftTopButton: UIButton!
    @IBOutlet weak var rightTopButton: UIButton!
    
    @IBOutlet weak var topRemindView: UIView!
    @IBOutlet weak var topRemindTitle: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var confirmButton: GradientBackStrokeButton!
    
    @IBOutlet weak var leftTopLabel: UILabel!
    @IBOutlet weak var rightTopLabel: UILabel!
    @IBOutlet weak var playersTable: PlayersTableView!
    @IBOutlet weak var groupsTable: GroupsTableView!
    
    class func initFromStoryBoard() -> ABookPlayerViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let player = storyBoard.instantiateViewController(withIdentifier: "Player") as! ABookPlayerViewController
        
        return player
    }
    
    fileprivate let user = PlayerButton.createForNavigationItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        // size
        leftTopButton.layer.cornerRadius = 4 * standWP
        rightTopButton.layer.cornerRadius = 4 * standWP
        setupTopButtons()
        
        hideBottom()
        topRemindView.transform = CGAffineTransform(translationX: 0, y: -height * 0.2)
        topRemindView.layer.addBlackShadow(4 * fontFactor)
        
        confirmButton.setupWithTitle("Confirm")
        confirmButton.isSelected = false
        
        topRemindTitle.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: .medium)
        
        // log
        if userCenter.userState != .login {
            login()
        }
        
        // navi
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: user)
        
        // setup
        leftTopLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        rightTopLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
    }
    
    fileprivate func hideBottom() {
         bottomView.transform = CGAffineTransform(translationX: 0, y: height * 0.1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Player"
        
        if userCenter.userState == .login {
            user.isUserInteractionEnabled = false
            if leftOnShow {
                reloadPlayerView()
            }else {
                reloadGroupView()
            }
        }else {
            user.isUserInteractionEnabled = false
            user.buttonAction = login
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if leftOnShow {
            if playersTable.searchController.isActive {
                playersTable.searchController.dismiss(animated: true) {
                    self.navigationController?.isNavigationBarHidden = false
                }
            }
        }
    }
    
    fileprivate func login() {
        let loginVC = LoginViewController.createFromNib()
        loginVC.hidesBottomBarWhenPushed = true
        loginVC.invokeFinishedClosure = reloadPlayerView
        
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func reloadPlayerView() {
        if userCenter.userState == .login {
            user.setWithCurrentUser()
            playersTable.players = userCenter.pseudoUserKeys
            playersTable.reloadData()
        }
    }
    
    func reloadGroupView() {
        groupsTable.groups = userCenter.userGroups
        groupsTable.reloadData()
    }
    
    
    @IBAction func toPersonTable(_ sender: Any) {
        leftOnShow = true
        playersTable.isHidden = false
        reloadPlayerView()
        hideBottom()
    }
    
    @IBAction func toGroupTable(_ sender: Any) {
        leftOnShow = false
        playersTable.isHidden = true
        reloadGroupView()
        
        if bottomView.transform == .identity {
            hideBottom()
        }
    }
    
    @IBAction func confirmChosen(_ sender: Any) {
        playersTable.chooseAsTarget()
        user.setWithCurrentUser()
        
        // TODO: -------------- load record??
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.transform = CGAffineTransform(translationX: 0, y: height * 0.1)
            self.topRemindView.transform = CGAffineTransform.identity
        }) { (true) in
            UIView.animate(withDuration: 0.1, delay: 0.2, options: .curveEaseIn, animations: {
                self.topRemindView.transform = CGAffineTransform(translationX: 0, y: -height * 0.1)
            }, completion: { (true) in
                if self.navigationController != nil {
                    if self.backToIntroAfterChoose {
                        for vc in self.navigationController!.viewControllers {
                            if vc.isKind(of: IntroPageViewController.self) {
                                self.navigationController?.popToViewController(vc, animated: true)
                                return
                            }
                        }
                    }
                    self.navigationController?.popViewController(animated: true)
                }
                
                self.currentUserIsChanged?()
            })
        }
    }
    
    fileprivate func setupTopButtons() {
        leftTopButton.isSelected = leftOnShow
        rightTopButton.isSelected = !leftOnShow
    }
}
