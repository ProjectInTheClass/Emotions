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
    var firstCard: Card
    var secondCard: Card
    var thirdCard: Card
    var isHeart: Bool = false
    var isGood: Int = 0

    init(postID: String, userEmail: String, content: String, firstCard: Card, secondCard: Card, thirdCard: Card, date: Int) {
        self.postID = postID
        self.userEmail = userEmail
        self.date = date
        self.content = content
        self.firstCard = firstCard
        self.secondCard = secondCard
        self.thirdCard = thirdCard
    }
}
