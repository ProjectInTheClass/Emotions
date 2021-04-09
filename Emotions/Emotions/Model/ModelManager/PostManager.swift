//
//  PostManager.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation

class PostManager {
    static let shared = PostManager()
    
    let posts: [Post] = [
        Post(postID: "1", userEmail: "phs880623@gmail.com", content: "만물은 인간이 뭇 풀이 가치를 불러 끓는다. 그들을 속에서 열락의 구할 청춘은 관현악이며, 자신과 있으랴? 시들어 가치를 기관과 있는 오아이스도 긴지라 듣는다. 풀이 이상의 그것을 일월과 우리 것이다. 그들은 인간이 청춘 같이 하였으며 만물은 인간이 뭇 풀이 가치를 불러 끓는다. 그들을 속에서 열락의 구할 청춘은 관현악이며, 자신과 있으랴? 시들어 가치를 기관과 있는 오아이스도 긴지라 듣는다. 풀이 이상의 그것을 일월과 우리 것이다. 그들은 인간이 청춘 같이 하였으며", firstCard: CardManager.shared.cards[0], secondCard: CardManager.shared.cards[1], thirdCard: CardManager.shared.cards[2], date: 1),
        Post(postID: "2", userEmail: "phs880623@gmail.com",  content: "만물은 인간이 뭇 풀이 가치를 불러 끓는다. 그들을 속에서 열락의 구할 청춘은 관현악이며, 자신과 있으랴? 시들어 가치를 기관과 있는 오아이스도 긴지라 듣는다. 풀이 이상의 그것을 일월과 우리 것이다. 그들은 인간이 청춘 같이 하였으며 만물은 인간이 뭇 풀이 가치를 불러 끓는다. 그들을 속에서 열락의 구할 청춘은 관현악이며, 자신과 있으랴? 시들어 가치를 기관과 있는 오아이스도 긴지라 듣는다. 풀이 이상의 그것을 일월과 우리 것이다. 그들은 인간이 청춘 같이 하였으며", firstCard: CardManager.shared.cards[2], secondCard: CardManager.shared.cards[0], thirdCard: CardManager.shared.cards[1], date: 2),
        Post(postID: "3", userEmail: "phs880623@gmail.com", content: "만물은 인간이 뭇 풀이 가치를 불러 끓는다. 그들을 속에서 열락의 구할 청춘은 관현악이며, 자신과 있으랴? 시들어 가치를 기관과 있는 오아이스도 긴지라 듣는다. 풀이 이상의 그것을 일월과 우리 것이다. 그들은 인간이 청춘 같이 하였으며 만물은 인간이 뭇 풀이 가치를 불러 끓는다. 그들을 속에서 열락의 구할 청춘은 관현악이며, 자신과 있으랴? 시들어 가치를 기관과 있는 오아이스도 긴지라 듣는다. 풀이 이상의 그것을 일월과 우리 것이다. 그들은 인간이 청춘 같이 하였으며", firstCard: CardManager.shared.cards[2], secondCard: CardManager.shared.cards[2], thirdCard: CardManager.shared.cards[2], date: 3),
        Post(postID: "4", userEmail: "phs880623@gmail.com", content: "만물은 인간이 뭇 풀이 가치를 불러 끓는다. 그들을 속에서 열락의 구할 청춘은 관현악이며, 자신과 있으랴? 시들어 가치를 기관과 있는 오아이스도 긴지라 듣는다. 풀이 이상의 그것을 일월과 우리 것이다. 그들은 인간이 청춘 같이 하였으며 만물은 인간이 뭇 풀이 가치를 불러 끓는다. 그들을 속에서 열락의 구할 청춘은 관현악이며, 자신과 있으랴? 시들어 가치를 기관과 있는 오아이스도 긴지라 듣는다. 풀이 이상의 그것을 일월과 우리 것이다. 그들은 인간이 청춘 같이 하였으며", firstCard: CardManager.shared.cards[0], secondCard: CardManager.shared.cards[1], thirdCard: CardManager.shared.cards[2], date: 4),
        Post(postID: "5", userEmail: "phs880623@gmail.com", content: "만물은 인간이 뭇 풀이 가치를 불러 끓는다. 그들을 속에서 열락의 구할 청춘은 관현악이며, 자신과 있으랴? 시들어 가치를 기관과 있는 오아이스도 긴지라 듣는다. 풀이 이상의 그것을 일월과 우리 것이다. 그들은 인간이 청춘 같이 하였으며 만물은 인간이 뭇 풀이 가치를 불러 끓는다. 그들을 속에서 열락의 구할 청춘은 관현악이며, 자신과 있으랴? 시들어 가치를 기관과 있는 오아이스도 긴지라 듣는다. 풀이 이상의 그것을 일월과 우리 것이다. 그들은 인간이 청춘 같이 하였으며", firstCard: CardManager.shared.cards[0], secondCard: CardManager.shared.cards[0], thirdCard: CardManager.shared.cards[0], date: 5),
    ]
}
