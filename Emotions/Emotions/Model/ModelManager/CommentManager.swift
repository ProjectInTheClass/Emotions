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
        commentsDataQuery?.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard let self = self else { return }
            guard let snapshotValue = snapshot.value as? [String:Any] else { return }
            for data in snapshotValue.values {
                let comment = data as! [String:Any]
                let newComment = Comment(dictionary: comment)
                self.comments.append(newComment)
            }
            self.comments.sort { $0.date < $1.date }
            completion(true)
        })
    }
}
