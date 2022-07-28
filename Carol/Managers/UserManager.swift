//
//  UserManager.swift
//  Carol
//
//  Created by Vi Nguyen on 25/07/2022.
//

import Foundation
import RxSwift
import RxRelay

class UserManager {
    private static let instance = UserManager()
    public var userInfo: UserInfo? {
        didSet {
            loggedInUser.accept(userInfo)
        }
    }
    
    public static func shared() -> UserManager {
        return instance
    }
    
    public var loggedInUser = BehaviorRelay<UserInfo?>(value: nil)
    
    public func getKeychainItemWrapper() -> KeychainItemWrapper? {
        return KeychainItemWrapper.init(identifier: Bundle.main.bundleIdentifier, accessGroup: nil)
    }
}

extension UserManager {
    public func updateUserInfo(_ user: UserInfo) {
        self.userInfo = user
    }
    
    public func getUserInfo() -> UserInfo? {
        return self.userInfo
    }
    
}
