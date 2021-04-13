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

func dateToDday(post: Post) -> String {
    let endDate = Date(timeIntervalSince1970: Double(post.date))
    let dateToInt = Int(endDate.timeIntervalSinceNow / 24 / 60 / 60)
    let dateToDday = "D-\(dateToInt)"
    return dateToDday
}
