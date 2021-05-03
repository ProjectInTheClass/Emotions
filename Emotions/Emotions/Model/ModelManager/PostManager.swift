//
//  PostManager.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import UIKit

class PostManager {
    static let shared = PostManager()
    private let numberOfOneLoad = 5
    
    var starPosts = [Post]() // 별 (추천) 많은 순 = 랭킹 10위까지 (2번째 세그먼티드는 없앴음 = 비슷한 감정)

    func loadPostsByStarPoint(currentUserUID: String, completion: @escaping (Bool)->Void){
        var orderedQuery: DatabaseQuery?
        orderedQuery = postsRef.queryOrdered(byChild: "starPoint").queryLimited(toLast: 10)
        orderedQuery?.observeSingleEvent(of: .value, with: { snapshot in
            var snapshotData = snapshot.children.allObjects
            snapshotData.reverse()
            
            for anyDatum in snapshotData {
                let snapshotDatum = anyDatum as! DataSnapshot
                //                let postkey = snapshotDatum.key
                let dicDatum = snapshotDatum.value as! [String:Any]
                let post = Post(currentUserUID: currentUserUID, dictionary: dicDatum)
                
                if let firstCardID = dicDatum["firstCardID"] as? String {
                    post.firstCard = CardManager.shared.searchCardByID(cardID: firstCardID)
                }
                if let secondCardID = dicDatum["secondCardID"] as? String {
                    post.secondCard = CardManager.shared.searchCardByID(cardID: secondCardID)
                }
                if let thirdCardID = dicDatum["thirdCardID"] as? String {
                    post.thirdCard = CardManager.shared.searchCardByID(cardID: thirdCardID)
                }
                
                let todaySecond = Int(Date().timeIntervalSince1970)
                if post.endDate - todaySecond <= 0 {
                    
                } else {
                    self.starPosts += [post]
                }
            }
            completion(true)
        })
    }
    
    var userPosts = [Post]() //나의 글 (2번째 탭)
    
    func loadUserPosts(currentUserUID: String, completion: @escaping (Bool)->Void) {
        var orderedQuery: DatabaseQuery?
        orderedQuery = postsRef.queryOrdered(byChild: "userID").queryEqual(toValue: Auth.auth().currentUser?.uid)
        orderedQuery?.observe(.childAdded, with: { snapshot in
            let postDic = snapshot.value as! [String:Any]
            let post = Post(currentUserUID: currentUserUID, dictionary: postDic)
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
    
    var myHeartPosts = [Post]() // 하트 좋아요 누른거 (공감)

    func loadPostsByHeart(currentUserUID: String, completion: @escaping (Bool)->Void){
        var myPostQuery: DatabaseQuery?
        myPostQuery = postsRef.queryOrdered(byChild: "heartUser").queryStarting(atValue: true)
        myPostQuery?.observe(.value, with: { (snapshot) in
            PostManager.shared.myHeartPosts = []
            let dictionary = snapshot.value as! [String:AnyObject]
            for postData in dictionary.values {
                let dicDatum = postData as! [String:AnyObject]
                for heartUser in dicDatum["heartUser"] as! [String:Bool] {
                    if Auth.auth().currentUser?.uid == heartUser.key {
                        let post = Post(currentUserUID: currentUserUID, dictionary: dicDatum)
                        if let firstCardID = dicDatum["firstCardID"] as? String {
                            post.firstCard = CardManager.shared.searchCardByID(cardID: firstCardID)
                        }
                        if let secondCardID = dicDatum["secondCardID"] as? String {
                            post.secondCard = CardManager.shared.searchCardByID(cardID: secondCardID)
                        }
                        if let thirdCardID = dicDatum["thirdCardID"] as? String {
                            post.thirdCard = CardManager.shared.searchCardByID(cardID: thirdCardID)
                        }
                        
                        let todaySecond = Int(Date().timeIntervalSince1970)
                        if post.endDate - todaySecond <= 0 {
                        } else {
                            self.myHeartPosts += [post]
                        }
                    }
                }
            }
            completion(true)
        })
    }
}
