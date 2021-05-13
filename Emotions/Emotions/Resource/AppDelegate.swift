//
//  AppDelegate.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/02.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Auth.auth().addStateDidChangeListener { auth, user in
            if auth.currentUser == nil {
                PostManager.shared.latestposts = []
                PostManager.shared.loadedPosts = []
                PostManager.shared.starPosts = []
                PostManager.shared.myHeartPosts = []
                PostManager.shared.userPosts = []
                PostManager.shared.loadPosts(currentUserUID: "") { success in
                    if success {
                        PostManager.shared.loadPostsByStarPoint()
                        NotificationCenter.default.post(name: NSNotification.Name("updateTableView"), object: nil)
                    }
                }
            } else {
                guard let currentUserUID = auth.currentUser?.uid else { return }
                PostManager.shared.latestposts = []
                PostManager.shared.loadedPosts = []
                PostManager.shared.starPosts = []
                PostManager.shared.myHeartPosts = []
                PostManager.shared.userPosts = []
                PostManager.shared.loadUserPosts(currentUserUID: currentUserUID) { success in }
                PostManager.shared.loadPosts(currentUserUID: currentUserUID) { success in
                    if success {
                        PostManager.shared.loadPostsByStarPoint()
                        PostManager.shared.loadPostsByHeart(currentUserUID: currentUserUID)
                        NotificationCenter.default.post(name: NSNotification.Name("updateTableView"), object: nil)
                    }
                }
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

