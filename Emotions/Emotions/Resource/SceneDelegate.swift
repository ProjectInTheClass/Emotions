//
//  SceneDelegate.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/02.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    
    
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        if let currentUser = Auth.auth().currentUser {
            let currentUserUID = currentUser.uid
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
        } else {
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
        }
    }


}

