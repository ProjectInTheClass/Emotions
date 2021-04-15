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
    
    // 먼저, isHeart & isGood
    // firebase에서 받아올 때는 두 프로퍼티 모두 checkHeartAndStar() 후에 bool값을 조정
    // 이미 내가 좋아요를 누른 경우, 내가 스타를 누른 경우(스타를 누른 경우에는 스타포인트도 감소되도록)
    var heartUser = [String]()
    var starUser = [String]()
    var isStar = false
    var isHeart = false

    init(dictionary: [String:Any]) {
        self.postID = dictionary["postID"] as? String ?? ""
        self.userEmail = dictionary["userEmail"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.endDate = dictionary["endDate"] as? Int ?? 0
        self.starPoint = dictionary["starPoint"] as? Int ?? 0
        self.heartUser = dictionary["heartUser"] as? Array<String> ?? []
        self.starUser = dictionary["starUser"] as? Array<String> ?? []
        self.isHeart = heartUser.contains(userEmail)
        self.isStar = starUser.contains(userEmail)
        // 카드id로 카드가져오기
        if let firstCardID = dictionary["firstCardID"] as? String {
            self.firstCard = CardManager.shared.searchCardByID(cardID: firstCardID)
        }
        if let secondCardID = dictionary["secondCardID"] as? String {
            self.secondCard = CardManager.shared.searchCardByID(cardID: secondCardID)
        }
        if let thirdCardID = dictionary["thirdCardID"] as? String {
            self.thirdCard = CardManager.shared.searchCardByID(cardID: thirdCardID)
        }
    }
}
