//
//  UserDefaultsManager.swift
//  Friends
//
//  Created by Emiray Nakip on 4.11.2021.
//

import Foundation

class UserDefaultsManager {
    enum Key: String {
        case isSignedIn
    }
    
    static let shared: UserDefaultsManager = {
        return UserDefaultsManager()
    }()
    
    func signInUser() {
        UserDefaults.standard.set(true, forKey: Key.isSignedIn.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func isUserSignedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: Key.isSignedIn.rawValue)
    }
    
    func signOutUser() {
        UserDefaults.standard.set(false, forKey: Key.isSignedIn.rawValue)
        UserDefaults.standard.synchronize()
    }
    
}
