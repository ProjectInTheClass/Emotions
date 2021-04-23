//
//  CommentManager.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation
import FirebaseDatabase

struct CommentManager {
    
    static func downloadComment(post: Post) -> [Comment] {
        var queriedComments = [Comment]()
        var commentsDataQuery: DatabaseQuery?
        commentsDataQuery?.queryOrdered(byChild: "postID").queryEqual(toValue: post.postID)
        commentsDataQuery?.observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? [String:Any] ?? [:]
            let newComment = Comment(dictionary: snapshotValue)
            queriedComments.append(newComment)
        })
        return queriedComments
    }
    
    func uploadComment(dictionary: [String:Any]) {
        commentRef.childByAutoId().setValue(dictionary)
    }
}
