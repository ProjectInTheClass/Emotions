//
//  Post.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/02.
//

import Foundation

class Post {
    var postID: String
    var userEmail: String
    var content: String
    var endDate: Int
    var firstCard: Card?
    var secondCard: Card?
    var thirdCard: Card?
    var starPoint: Int
    var userID: String
    var heartUser = [String:Bool]()
    var starUser = [String:Bool]()
    var reportedUser = [String:Bool]()
    var isStar = false
    var isHeart = false

    init(currentUserUID: String, dictionary: [String:Any]) {
        self.userID = dictionary["userID"] as? String ?? ""
        self.postID = dictionary["postID"] as? String ?? ""
        self.userEmail = dictionary["userEmail"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.endDate = dictionary["endDate"] as? Int ?? 0
        self.starPoint = dictionary["starPoint"] as? Int ?? 0
        self.heartUser = dictionary["heartUser"] as? [String:Bool] ?? [:]
        self.starUser = dictionary["starUser"] as? [String:Bool] ?? [:]
        self.reportedUser = dictionary["reportedUser"] as? [String:Bool] ?? [:]
        let heartDic = heartUser.filter { $0.key == currentUserUID }
        let startDic = starUser.filter { $0.key == currentUserUID }
        self.isHeart = heartDic[currentUserUID] ?? false
        self.isStar = startDic[currentUserUID] ?? false
    }
}
