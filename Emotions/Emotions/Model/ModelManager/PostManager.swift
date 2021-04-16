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
    
    var starPosts = [Post]()
    private let numberOfOneLoad = 5
    
    func loadPostsByStarPoint(completion: @escaping (Bool)->Void){
        var orderedQuery: DatabaseQuery?
        orderedQuery = database.child("posts").queryOrdered(byChild: "starPoint").queryLimited(toLast: 10)
        orderedQuery?.observeSingleEvent(of: .value, with: { snapshot in
            var snapshotData = snapshot.children.allObjects
            snapshotData.reverse()
            
            for anyDatum in snapshotData {
                let snapshotDatum = anyDatum as! DataSnapshot
                //                let postkey = snapshotDatum.key
                let dicDatum = snapshotDatum.value as! [String:Any]
                let post = Post(dictionary: dicDatum)
                
                self.starPosts += [post]
            }
            completion(true)
        })
    }
    
    var sympathyPosts = [Post]()
    
    func loadPostsBySympathy(completion: @escaping (Bool)->Void) {
        sympathyPosts = []
        completion(true)
    }
}
