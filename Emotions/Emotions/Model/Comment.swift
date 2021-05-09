//
//  Comment.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation

struct Comment {
    var commentID: String
    var postID: String
    var userName: String
    var userEmail: String
    var content: String
    var date: Int
    var imageURL: String
    
    // firebase에서 받아오는거 말고, comment를 user가 생성할 때는 date에 timeIntervalSince1970로!
    // comments의 사용자 이미지는 userEmail로 storage에서 받아온다.
    // 아직 코멘트 적는거 구현하지 않았기 때문에, 이용할 때 써보자.
    init(dictionary: [String:Any]) {
        self.commentID = dictionary["commentID"] as? String ?? ""
        self.postID = dictionary["postID"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.userEmail = dictionary["userEmail"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.date = dictionary["date"] as? Int ?? 0
        self.imageURL = dictionary["imageURL"] as? String ?? ""
    }
}
