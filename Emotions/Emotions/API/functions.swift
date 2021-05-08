//
//  functions.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/13.
//

import Foundation
import UIKit

// 포스트의 dateLabel 용
func dateToDday(post: Post) -> String {
    let endDate = Date(timeIntervalSince1970: Double(post.endDate))
    let dateToInt = Int(endDate.timeIntervalSinceNow / 24 / 60 / 60)
    let dateToDday = "D-\(dateToInt)"
    return dateToDday
}

func dateToDdayForMyPost(post: Post) -> String {
    let endDate = Date(timeIntervalSince1970: Double(post.endDate))
    let dateToInt = Int(endDate.timeIntervalSinceNow / 24 / 60 / 60)
    let dateToDday = "\(dateToInt)일 후 정리"
    return dateToDday
}

// 코멘트의 dateLabel 용
func dateToMakeDay(comment: Comment) -> String {
    let today = Int(Date().timeIntervalSince1970)
    let commentDate = comment.date
    let dateInterval = today - commentDate
    if dateInterval < 24*60*60 {
        let hourDateInterval = dateInterval / 60 / 60
        let dateToMakeDay = "\(hourDateInterval)시간 전"
        return dateToMakeDay
    } else {
        let dayDateInterval = dateInterval / 60 / 60 / 24
        let dateToMakeDay = "\(dayDateInterval)일 전"
        return dateToMakeDay
    }
}

func stringToDate(date: Date) -> String {
   let formatter = DateFormatter()
   formatter.dateFormat = "yyyy년 MM월 dd일"
   return formatter.string(from: date)
}
