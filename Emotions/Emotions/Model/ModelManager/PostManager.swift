//
//  PostManager.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation

class PostManager {
    static let shared = PostManager()
    
    var posts: [Post] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("postsValueChanged"), object: nil)
        }
    }
}
