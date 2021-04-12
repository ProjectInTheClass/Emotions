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
    var date: Int
    var firstCard: Card?
    var secondCard: Card?
    var thirdCard: Card?
    var isHeart: Bool = false
    var isGood: Bool = false
    
    // 좋아요 포인트 제도 어떻게 할까?
    var point: Int = 0

    init(postID: String, userEmail: String, content: String, firstCard: Card?, secondCard: Card?, thirdCard: Card?, date: Int) {
        self.postID = postID
        self.userEmail = userEmail
        self.date = date
        self.content = content
        if let firstCard = firstCard {
            self.firstCard = firstCard
        }
        if let secondCard = secondCard {
            self.secondCard = secondCard
        }
        if let thirdCard = thirdCard {
            self.thirdCard = thirdCard
        }
    }
}
