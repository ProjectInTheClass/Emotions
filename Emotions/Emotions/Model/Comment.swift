//
//  Comment.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation


struct Comment {
    var postID: String
    var userNickName: String
    var userEmail: String
    var content: String
    var date: Int
    
    init(postID: String, userNickName: String, userEmail: String, content: String, date: Int) {
        self.postID = postID
        self.userNickName = userNickName
        self.userEmail = userEmail
        self.content = content
        self.date = date
    }
}
