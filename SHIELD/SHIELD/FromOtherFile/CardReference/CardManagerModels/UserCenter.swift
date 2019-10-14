//
//  UserCenter.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/15.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

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
    
    
    func Key() -> String {
        if (registertedUser != nil) {
            return (registertedUser?.key) ?? "Wrong"
        }
        
        if (pseudoUser != nil) {
            return (pseudoUser?.key)!
        }
        
        // default by using guest id
        return "All Nil"
    }
    
    func userInfo() -> UserInfoObjModel! {
        var obj = UserInfoObjModel()
        // login
        if (registertedUser != nil) {
            obj = registertedUser!.details()
            obj.imageObj = registertedUser!.imageObj
            if obj.name == nil {
                obj.name = userCenter.loginUserObj.displayName
            }
        }
        
        if (pseudoUser != nil) {
            // pseudo
            obj = pseudoUser!.details()
            obj.imageObj = pseudoUser!.imageObj
            if obj.name == nil {
                obj.name = pseudoUser!.name
            }
        }
        
        return obj
    }
}

// object to keep following information:
// (1) current login user,  this is the main user who may "play" the risk model game
// (2) risk mmodel game target user, this is the user whom the current login user is playing for.  for example, if I am currently logged in as Hui and I may "play" for myself (as registerted) or a fake user "Obama" as as pseudo User
// if the user of this app is not logged in (isLogged) then only the "GUEST" can be used played for
enum UserState {
//    case guest
    case login
    case none
}

// has information of currently login user (or as guest), and game target user.  
// !!! before moving onto to new REST api a userID (UUID) is saved in UserDefaults.standard with key "user_\(name!)" and UserInfoModel object is saved into local coredata db that can be accessed via given userID later
class UserCenter {
    var tempWeight = [String: Float]()
    
    // singleton
    static let sharedCenter = UserCenter()
    
    // unlogged, after logged in, change to true
    var userState = UserState.none {
        didSet {
            // each time when we change user state we need to make sure:
            // set the game target user as current "loginUser"
            currentGameTargetUser.registertedUser = loginUserObj
            currentGameTargetUser.pseudoUser = nil
        }
    }
    var jwt :String?
    var loginName: String!
    var loginKey: String!
    
    // detailed info of current login user
    var loginUserObj = UserObjModel() {
        didSet{
            loginKey = loginUserObj.key
        }
    }
    
    // load login user
    func loadUser(_ accessInfo: UserLoginObjModel) {
        loginKey = accessInfo.userKey
        
        jwt = accessInfo.jwt
    }
    
    //////////////////////////
    // current card game target user (set each time a game target user is selected)
    var currentGameTargetUser = CardTargetUser()
    
    // backend access key for current login user
    // game targets for registered user or pseudo users
    // collection of pseudoUsers created by the logged in user.  [pseudoUserKey, PseudoUserObjModel]
    fileprivate var pseudoUserList = [String : PseudoUserObjModel]()
    
    // all pseudo users avialibel for currently logged in user
    var pseudoUserKeys: [String] {
        return Array(pseudoUserList.keys)
    }
    
    var pseudoUsers: [PseudoUserObjModel] {
        let current = userCenter.currentGameTargetUser
        if let currentpseudoUser = getPseudoUser(current.Key()) {
            var all = [currentpseudoUser]
            for one in Array(pseudoUserList.values) {
                if current.Key() != one.key {
                    all.append(one)
                }
            }
            
            return all
        }else {
            return Array(pseudoUserList.values)
        }
    }

    func getPseudoUser(_ userKey: String?) -> PseudoUserObjModel? {
        if userKey == nil {
            return nil
        }
        return pseudoUserList[userKey!]
    }
    
    func deletePseudoUser(_ userKey: String) {
        pseudoUserList[userKey] = nil
        
        if localDB.database.open() {
            localDB.deleteByKey(userKey, inTable: PseudoUserObjModel.tableName)
            
            // measurements
            localDB.deleteByColumn("PseudoUserKey", value: userKey, inTable: MeasurementObjModel.tableName)
            
            // change in group
            localDB.database.close()
        }
    }
    
    func addOrChangePseudoUser(_ user: PseudoUserObjModel, saveToLocal: Bool) {
        if user.displayName == nil {
            user.displayName = user.name
        }
        pseudoUserList[user.key] = user
        
        if saveToLocal && localDB.database.open() {
            user.saveToLocalDatabase()
            localDB.database.close()
        }
    }
    
    //////////////////////////
    func setLoginUserAsTarget() {
        currentGameTargetUser.registertedUser = loginUserObj
        currentGameTargetUser.pseudoUser = nil
    }
    
    func setUserAsTarget(_ key: String) {
        if key == currentGameTargetUser.Key() {
            return
        }
        
        if key == loginKey {
            setLoginUserAsTarget()
        }else {
            currentGameTargetUser.registertedUser = nil
            currentGameTargetUser.pseudoUser = getPseudoUser(key)
        }
    }
    
    func getDisplayNameOfKey(_ userKey: String) -> String? {
        if userCenter.userState == .login {
            return userKey == loginKey ? loginUserObj.displayName : getPseudoUser(userKey)!.displayName
        }else {
            return "Login"
        }
    }

    
    func getDobStringOfUser(_ userKey: String!) -> String! {
        if userKey == nil {
            return nil
        }
        
        if userKey == loginUserObj.key {
            return loginUserObj.dobString
        }else if let pseudoUser = getPseudoUser(userKey) {
            return pseudoUser.dobString
        }
        
        return nil
    }
    
    // UserInfo
    func getUserOfUserInfoKey(_ userInfoKey: String) -> String! {
        if userState == .login  {
            if loginUserObj.userInfoKey == userInfoKey {
                return loginUserObj.key
            }else {
                for (key, pseudoUser) in pseudoUserList {
                    if pseudoUser.userInfoKey == userInfoKey {
                        return key
                    }
                }
            }
        }
        
        return nil
    }

    
    // UserGroup
    fileprivate var userGroupList = [String: UserGroupObjModel]()
    var userGroupKeys: [String] {
        return Array(userGroupList.keys)
    }
    
    var userGroups: [UserGroupObjModel] {
        return Array(userGroupList.values)
    }
    
    func getUserGroup(_ groupKey: String) -> UserGroupObjModel? {
        return userGroupList[groupKey]
    }
    
    func deleteUserGroup(_ groupKey: String) {
        userGroupList[groupKey] = nil
        
        if localDB.database.open() {
            localDB.deleteByKey(groupKey, inTable: UserGroupObjModel.tableName)
            localDB.database.close()
        }
        
    }
    func addOrChangeUserGroup(_ group: UserGroupObjModel, saveToLocal: Bool) {
        userGroupList[group.key] = group
        
        if saveToLocal && localDB.database.open() {
            group.saveToLocalDatabase()
            localDB.database.close()
        }
    }
    
    func logOut()  {
        loginUserObj = UserObjModel()
        userState = .none
    }
}
