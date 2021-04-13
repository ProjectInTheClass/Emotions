//
//  PostManager.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation
import UIKit
class PostManager {
    static let shared = PostManager()
    
    var posts: [Post] = [
        Post(postID: "defaulPostForProtectNil##", userEmail: "phs880623@gmail.com", content: "안녕하세요? 언젠가는 뭍이거나 사라질 기본글입니다. 만드는 과정이 쉽지만은 않네요. 생각대로 딱딱 되면 좋으련만 그렇게 안되니 시행착오가 많습니다. 그래도 이런 서비스를 준비한다는게 한편으로는 마음이 좋습니다. 부디 많은 사람에게 위로와 격려가 되길 바랍니다.", firstCard: CardManager.shared.cards[4], secondCard: CardManager.shared.cards[4], thirdCard: CardManager.shared.cards[4], date: 1896198741987589175),
        Post(postID: "defaulPostForProtectNil##", userEmail: "phs880623@gmail.com", content: "안녕하세요? 언젠가는 뭍이거나 사라질 기본글입니다. 만드는 과정이 쉽지만은 않네요. 생각대로 딱딱 되면 좋으련만 그렇게 안되니 시행착오가 많습니다. 그래도 이런 서비스를 준비한다는게 한편으로는 마음이 좋습니다. 부디 많은 사람에게 위로와 격려가 되길 바랍니다.", firstCard: CardManager.shared.cards[4], secondCard: CardManager.shared.cards[4], thirdCard: CardManager.shared.cards[4], date: 1896198741987589175)
    ] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("postsValueChanged"), object: nil)
        }
    }
    
    func fetchSympathyPosts(posts: [Post]) -> [Post] {
        let sympathyPosts = posts.filter { $0.isHeart == true }
        return sympathyPosts
    }
    
    func fetchLatestPosts(posts: [Post]) -> [Post] {
        let latestPosts = posts.sorted { $0.date > $1.date }
        return latestPosts
    }
}
