//
//  DataManager.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/14.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class DataManager {
    static let shared = DataManager()
    
    let storage = Storage.storage().reference()
    
    private let numberOfOneLoad = 5
    
    var latestposts = [Post]()
    var loadedPosts = [Post]()
    //MARK: - download & upload Posts
    
    public func loadPosts(currentUserUID: String, completion: @escaping (Bool)->Void) {
        var orderedQuery: DatabaseQuery?
        orderedQuery = postsRef.queryOrdered(byChild: "endDate")
        orderedQuery?.observeSingleEvent(of: .value, with: { snapshot in
            var snapshotData = snapshot.children.allObjects
            snapshotData.reverse()
            
            for anyDatum in snapshotData {
                let snapshotDatum = anyDatum as! DataSnapshot
                let dicDatum = snapshotDatum.value as! [String:Any]
                let postkey = snapshotDatum.key
                if let isReportedDic = dicDatum["reportedUser"] as? [String:Bool] {
                    for isReportUser in isReportedDic {
                        let user = isReportUser.key
                        if Auth.auth().currentUser?.uid == user {
                            print("isReported")
                        } else {
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
                                postsRef.child(postkey).removeValue()
                            } else {
                                self.loadedPosts += [post]
                            }
                        }
                    }
                } else {
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
                        postsRef.child(postkey).removeValue()
                    } else {
                        self.loadedPosts += [post]
                    }
                }
            }
            self.latestposts += self.loadedPosts.prefix(self.numberOfOneLoad)
            completion(true)
        })
    }
    
    public func loadFreshPosts(currentUserUID: String, completion: @escaping (Bool)->Void) {
        var filterQuery: DatabaseQuery?
        
        if let latestDate = self.latestposts.first?.endDate {
            filterQuery = postsRef.queryOrdered(byChild: "endDate").queryStarting(afterValue: latestDate)
        } else {
            filterQuery = postsRef.queryOrdered(byChild: "endDate").queryStarting(atValue: 0)
        }
        
        filterQuery?.observeSingleEvent(of: .value, with: { snapshot in
            var snapshotData = snapshot.children.allObjects
            snapshotData.reverse()
            
            var freshPostsChunk = [Post]()
            
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
                
                freshPostsChunk += [post]
            }
            self.loadedPosts.insert(contentsOf: freshPostsChunk, at: 0)
            self.latestposts.insert(contentsOf: freshPostsChunk, at: 0)
            completion(true)
        })
    }
    
    public func loadPastPosts(completion: @escaping (Bool)->Void){
        let pastPosts = self.loadedPosts.filter { $0.endDate < (self.latestposts.last?.endDate)! }
        let pastChunkPosts = pastPosts.prefix(numberOfOneLoad)
        
        if pastChunkPosts.count > 0 {
            self.latestposts += pastChunkPosts
            completion(true)
        }
    }
}
