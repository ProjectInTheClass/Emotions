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
    
    var currentUser = Auth.auth().currentUser
    
    // 애플 로그인 구현
    func appleLogin(completion: @escaping (Bool)->Void) {
        
    }
    
    // 현재 유저있는지 체크하기
    public func checkLogin(completion: @escaping (Bool)->Void) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if auth.currentUser == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
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



