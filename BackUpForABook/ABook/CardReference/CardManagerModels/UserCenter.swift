//
//  UserCenter.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/15.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import ABookData
import CoreData

// risk model target user
// keeping card processing result per user target
// there are two types of target users: registered user and pseudo user.
// if registertedUser is nil then the user is a pseudo uder.  always check registertedUser first
struct CardTargetUser {
    // set to system user as defualt
    var registertedUser: UserObjModel? {
        didSet {
            if registertedUser != nil {
                pseudoUser = nil
            }
        }
    }
    var pseudoUser: PseudoUserObjModel? {
        didSet {
            if pseudoUser != nil {
                registertedUser = nil
            }
        }
    }
    
    
    func Key()->String {
        
        if (registertedUser != nil) {
            return (registertedUser?.key) ?? UserCenter.guestUserID()
        }
        
        if (pseudoUser != nil) {
            return (pseudoUser?.key)!
        }
        
        // default by using guest id
        return UserCenter.guestUserID()
 
    }
    
    func userInfo()->UserinfoObjModel! {
        
        var obj = UserinfoObjModel()
        if (registertedUser != nil) {
           
            obj = (registertedUser?.details())!
            obj.imageObj = registertedUser?.imageObj
        }

        if (pseudoUser != nil) {
        
            obj = (pseudoUser?.details())!
            obj.imageObj = pseudoUser?.imageObj
        }

        return obj
    }
}

// object to keep following information:
// (1) current login user,  this is the main user who may "play" the risk model game
// (2) risk mmodel game target user, this is the user whom the current login user is playing for.  for example, if I am currently logged in as Hui and I may "play" for myself (as registerted) or a fake user "Obama" as as pseudo User
// if the user of this app is not logged in (isLogged) then only the "GUEST" can be used played for
enum UserState {
    case guest
    case login
    case none
}

// has information of currently login user (or as guest), and game target user.  
// !!! before moving onto to new REST api a userID (UUID) is saved in UserDefaults.standard with key "user_\(name!)" and UserInfoModel object is saved into local coredata db that can be accessed via given userID later
class UserCenter {
    // singleton
    static let sharedCenter = UserCenter()
    
    // unlogged, after logged in, change to true
    var userState = UserState.none {
        didSet {
            // each time when we change user state we need to make sure:
            AIDMetricCardsCollection.standardCollection.bNeed2ReloadModels = true
 
            // set the game target user as current "loginUser"
            currentGameTargetUser.registertedUser = loginUserObj
            currentGameTargetUser.pseudoUser = nil
        }
    }
    var loginKey :String?
    
    // detailed info of current login user
    var loginUserObj = UserObjModel()
    
    // backend access key for current login user
    var loginUserBackendAccess : UserLoginObjModel?
    
    // game targets for registered user or pseudo users
    // collection of pseudoUsers created by the logged in user.  [pseudoUserKey, PseudoUserObjModel]
    var pseudoUserList = [String : PseudoUserObjModel]()
    var registeredUserList = [String: UserObjModel]()
    
    var userAccess: UserAccess?
    var pseudoUserAccess: PseudoUserAccess?
    
    // used as buffer
    var userInfoFromBackend: UserObjModel?
    var pseudoUserFromBackend: PseudoUserObjModel?
    
    func loadUser(_ accesInfo: UserLoginObjModel, details: UserObjModel?) {
        
        loginUserBackendAccess = accesInfo
        
        if details != nil {
            loginUserObj = details!
        } else {
            loginUserObj = UserCenter.createUser((loginUserBackendAccess?.userKey)!)
            loginUserObj.displayName = loginUserBackendAccess?.displayname
        }
        
        registeredUserList[loginUserObj.key] = loginUserObj
        
        userState = .login
    }
    
    //////////////////////////
    // functions to bew removed or replaced
    // !!! userID and will be removed as part of switching over the new REST api backend
    
    // current log in user ID (UUID), read only
    var userID : String {
        return DbUtil.userId
    }
    
    // current card game target user (set each time a game target user is selected)
    var currentGameTargetUser = CardTargetUser() {
        didSet {
            // save risk model card input of previous target user first (if the palyer is registered)
            if  loginUserBackendAccess?.userKey != nil && userState == .login && currentGameTargetUser.Key() != oldValue.Key() {
//            CardSelectionResults.cachedCardProcessingResults.saveTargetUserCardResults(oldValue)
            }
        }
    }

    // get "SYSTEM" user
    class func systemUser()->UserObjModel? {
        return UserCenter.createUser(systemUserID())
    }
    
    // get "GUEST" user
    class func guestUser()->UserObjModel? {
        return UserCenter.createUser(guestUserID())
    }
    
    // all pseudo users avialibel for currently logged in user
    var pseudoUsers: [PseudoUserObjModel] {
        return Array(pseudoUserList.values)
    }

    // end of to be removed or replaced functions
    //////////////////////////
    
    class func createUser(_ key: String)-> UserObjModel {
        let user = UserObjModel()
        user.key = key
        return user
    }
    
    class func createPseudoUser(_ key: String)-> PseudoUserObjModel {
        let user = PseudoUserObjModel()
        user.key = key
        return user
    }
    
    func setLoginUserAsTarget() {
        currentGameTargetUser.registertedUser = loginUserObj
        currentGameTargetUser.pseudoUser = nil
    }
    
    class func systemUserID()-> String {
        return "b7711510-9c4b-11e6-80f5-76304dec7eb7"
    }
    
    class func guestUserID()-> String {
        return "d8d7c896-f2f1-11e6-bc64-92361f002671"
    }
    
    // add login in user into backend
    // !!! To Do,  will rework the logics so we will do this only once when new user is created and login
    func addUserToBackend(_ user: UserObjModel) {
        if userAccess == nil {
            userAccess = UserAccess(callback: self)
        }
        userAccess?.beginApi(nil)
        userAccess?.addOne(oneData: user)
    }
    
    // get user from backend
    func getUserFromBackend(_ userKey: String) {
        if userAccess == nil {
            userAccess = UserAccess(callback: self)
        }
        userAccess?.beginApi(nil)
        userAccess?.getOneByKey(key: userKey)
    }
    
    // add one pseudo user to backend
    func addPseudoUserToBackend(_ pseudoUser: PseudoUserObjModel) {
        if pseudoUserAccess == nil {
            pseudoUserAccess = PseudoUserAccess(callback: self)
        }
        pseudoUserAccess?.beginApi(nil)
        pseudoUserAccess?.addOne(oneData: pseudoUser)
    }
    
    // get pseudoUser from backend
    func getpseudoUserFromBackend(_ userKey: String) {
        if pseudoUserAccess == nil {
            pseudoUserAccess = PseudoUserAccess(callback: self)
        }
        pseudoUserAccess?.beginApi(nil)
        pseudoUserAccess?.getOneByKey(key: userKey)
    }
}

// REST api access event handler
extension UserCenter: DataAccessProtocal {
    
    func didFinishAddDataByKey(_ obj: AnyObject) {
        
    }
    
    func failedAddDataByKey(_ error: String) {
        
    }
    
    func didFinishGetDataByKey(_ obj: AnyObject) {
        
        if obj is UserObjModel {
            userInfoFromBackend = obj as! UserObjModel
        } else if obj is PseudoUserObjModel {
            pseudoUserFromBackend = obj as! PseudoUserObjModel
        }
    
    }
    
    func failedGetDataByKey(_ error: String) {
        
    }
}
