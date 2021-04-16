//
//  AuthManager.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/14.
//

import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    var currentUser = Auth.auth().currentUser
    
    public func loginUser(email: String?, password: String?, completion: @escaping (Bool)->Void) {
        if let email = email,
           let password = password {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    print("로그인 오류")
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
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
    
    public func registrationUser(email: String, password: String, nickName: String, completion: @escaping (Bool)->Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                print("이메일 등록 오류")
                completion(false)
                return }
            
            Auth.auth().addStateDidChangeListener { (auth, user) in
                self.currentUser = auth.currentUser
                
                guard let currentUser = auth.currentUser else { return }
                
                let changeRequest = currentUser.createProfileChangeRequest()
                changeRequest.displayName = nickName
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("닉네임 등록 에러 : \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("닉네임 정상 등록")
                        completion(true)
                    }
                }
                
                guard let image = UIImage(systemName: "person.circle") else { return }
                DataManager.shared.uploadUserImage(userImage: image, email: email) { (success) in
                    if success {
                        self.userImageUpdate()
                    } else {
                        print("업로드 실패")
                    }
                }
            }
        }
    }
    
    public func userImageUpdate() {
        guard let user = Auth.auth().currentUser else { print("AuthManager - registrationUser() - currentUser")
            return }
        let changeRequest = user.createProfileChangeRequest()
        DataManager.shared.downloadUserImage(email: user.email!) { (url) in
            if let url = url {
                changeRequest.photoURL = url
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("사진URL 등록에러 : \(error.localizedDescription)")
                    } else {
                        print("유저 이미지 등록")
                    }
                }
            }
        }
    }
    
    public func userImageDelete() {
        guard let currentUserEmail = AuthManager.shared.currentUser?.email else {
            print("사용자가 없습니다")
            return
        }
        let desertRef = DataManager.shared.storage.child(currentUserEmail.safetyDatabaseString() + ".jpg")
        desertRef.delete { error in
          if let error = error {
            print("사진 삭제 에러: \(error.localizedDescription)")
          } else {
            // File deleted successfully
          }
        }
    }
    
    public func deleteUser(password: String) {
        
        guard let currentUser = AuthManager.shared.currentUser else {
            print("사용자가 없습니다")
            return
        }
        
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: currentUser.email!, password: password)
        currentUser.reauthenticate(with: credential) { auth, error in
            if let error = error {
                print("재인증 에러 : \(error.localizedDescription)")
            } else {
                currentUser.delete { error in
                    if let error = error {
                        print("삭제 에러: \(error.localizedDescription)")
                    } else {
                        // Account deleted.
                    }
                }
            }
        }
    }
    
    public func checkLogin(completion: @escaping (Bool)->Void) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if auth.currentUser == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}