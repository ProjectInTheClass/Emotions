//
//  PostManager.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation
import FirebaseDatabase
import UIKit

class PostManager {
    static let shared = PostManager()
    private let numberOfOneLoad = 5
    
    var starPosts = [Post]()

    func loadPostsByStarPoint(completion: @escaping (Bool)->Void){
        var orderedQuery: DatabaseQuery?
        orderedQuery = postsRef.queryOrdered(byChild: "starPoint").queryLimited(toLast: 10)
        orderedQuery?.observeSingleEvent(of: .value, with: { snapshot in
            var snapshotData = snapshot.children.allObjects
            snapshotData.reverse()
            
            for anyDatum in snapshotData {
                let snapshotDatum = anyDatum as! DataSnapshot
                //                let postkey = snapshotDatum.key
                let dicDatum = snapshotDatum.value as! [String:Any]
                let post = Post(dictionary: dicDatum)
                
                if let firstCardID = dicDatum["firstCardID"] as? String {
                    post.firstCard = CardManager.shared.searchCardByID(cardID: firstCardID)
                }
                if let secondCardID = dicDatum["secondCardID"] as? String {
                    post.secondCard = CardManager.shared.searchCardByID(cardID: secondCardID)
                }
                if let thirdCardID = dicDatum["thirdCardID"] as? String {
                    post.thirdCard = CardManager.shared.searchCardByID(cardID: thirdCardID)
                }
                
                self.starPosts += [post]
            }
            completion(true)
        })
    }
    
    var userPosts = [Post]()
    
    func laodUserPosts(completion: @escaping (Bool)->Void) {
        var orderedQuery: DatabaseQuery?
        PostManager.shared.userPosts = []
        orderedQuery = postsRef.queryOrdered(byChild: "userID").queryEqual(toValue: AuthManager.shared.currentUser?.uid)
        orderedQuery?.observe(.childAdded, with: { snapshot in
            let postDic = snapshot.value as! [String:Any]
            let post = Post(dictionary: postDic)
            if let firstCardID = postDic["firstCardID"] as? String {
                post.firstCard = CardManager.shared.searchCardByID(cardID: firstCardID)
            }
            if let secondCardID = postDic["secondCardID"] as? String {
                post.secondCard = CardManager.shared.searchCardByID(cardID: secondCardID)
            }
            if let thirdCardID = postDic["thirdCardID"] as? String {
                post.thirdCard = CardManager.shared.searchCardByID(cardID: thirdCardID)
            }
            self.userPosts += [post]
            completion(true)
        })
    }
    
    var myHeartPosts = [Post]()

    func loadPostsByHeart(completion: @escaping (Bool)->Void){
        var myPostQuery: DatabaseQuery?
        myPostQuery = postsRef.queryOrdered(byChild: "heartUser").queryStarting(atValue: true)
        myPostQuery?.observe(.value, with: { (snapshot) in
            PostManager.shared.myHeartPosts = []
            let dictionary = snapshot.value as! [String:AnyObject]
            for postData in dictionary.values {
                let dicDatum = postData as! [String:AnyObject]
                for heartUser in dicDatum["heartUser"] as! [String:Bool] {
                    if AuthManager.shared.currentUser?.uid == heartUser.key {
                        let post = Post(dictionary: dicDatum)
                        if let firstCardID = dicDatum["firstCardID"] as? String {
                            post.firstCard = CardManager.shared.searchCardByID(cardID: firstCardID)
                        }
                        if let secondCardID = dicDatum["secondCardID"] as? String {
                            post.secondCard = CardManager.shared.searchCardByID(cardID: secondCardID)
                        }
                        if let thirdCardID = dicDatum["thirdCardID"] as? String {
                            post.thirdCard = CardManager.shared.searchCardByID(cardID: thirdCardID)
                        }
                        self.myHeartPosts += [post]
                    }
                }
            }
            completion(true)
        })
    }
}
