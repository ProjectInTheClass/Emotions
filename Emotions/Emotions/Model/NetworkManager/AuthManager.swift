//
//  AuthManager.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/14.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import CryptoKit

class AuthManager {
    static let shared = AuthManager()
    
    // 로그아웃
    public func logoutUser(completion: (Bool)->Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            print("로그아웃에 오류")
            completion(false)
            return
        }
    }
    
}



