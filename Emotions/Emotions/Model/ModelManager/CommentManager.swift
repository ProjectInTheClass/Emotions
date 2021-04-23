//
//  CommentManager.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation
import FirebaseDatabase

class CommentManager {
    static let shared = CommentManager()
    
    var comments = [Comment]()
    
    func downloadComment(post: Post, completion: @escaping (Bool)->Void){
        self.comments = []
        var commentsDataQuery: DatabaseQuery?
        commentsDataQuery = commentRef.queryOrdered(byChild: "postID").queryEqual(toValue: post.postID)
        print(post.postID)
        commentsDataQuery?.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as? [String:Any] ?? [:]
            let newComment = Comment(dictionary: snapshotValue)
            self.comments.append(newComment)
            completion(true)
        })
    }
    
    static func uploadComment(dictionary: [String:Any]) {
        commentRef.childByAutoId().setValue(dictionary)
    }
}
