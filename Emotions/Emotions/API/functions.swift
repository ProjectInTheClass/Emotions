//
//  functions.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/13.
//

import Foundation
import UIKit
import FirebaseAuth

// 포스트의 dateLabel 용
func dateToDday(post: Post) -> String {
    let endDate = post.endDate
    let today = Int(Date().timeIntervalSince1970)
    let leftDate = endDate - today
    let dateToInt = Int(leftDate / 24 / 60 / 60)
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

struct BadWords: Codable {
    var badwords: [String]
}

func loadBadWordsFromJson() -> [String] {
    if let path = Bundle.main.path(forResource: "badwords", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                let badwordsModel = try JSONDecoder().decode(BadWords.self, from: data)
                return badwordsModel.badwords
            }
            catch {
                print("decode error")
                return []
            }
        }
        catch {
            print("path error")
            return []
        }
    } else {
        print("path nil")
        return []
    }
}

func checkBadWords(content: String) -> Bool {
    let badwords = loadBadWordsFromJson()
    for badword in badwords {
        if content.contains(badword) {
            return true
        }
    }
    return false
}

func checkAbusiveUser(reportedUser: [String:Bool]) -> Bool {
    for isReportUser in reportedUser {
        let user = isReportUser.key
        if Auth.auth().currentUser?.uid == user {
            return true
        }
    }
    return false
}
