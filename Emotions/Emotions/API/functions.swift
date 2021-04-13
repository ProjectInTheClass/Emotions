//
//  functions.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/13.
//

import Foundation
import UIKit

func deletePostAtEndDate(post: Post) {
    let nowSecond = Int(Date().timeIntervalSince1970)
    let postSecond = post.date
    if postSecond - nowSecond <= 0 {
        
    } else {
        
    }
}
