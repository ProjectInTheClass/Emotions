//
//  Constants.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/17.
//

import Foundation
import Firebase

let logoImage = "logoImage"
let InfoCircle = "Info Circle"
let emotionDeepGreen = "emotionDeepGreen"
let emotionLightGreen = "emotionLightGreen"
let emotionDeepPink = "emotionDeepPink"
let emotionLightPink = "emotionLightPink"
let postCell = "postCell"
let database = Database.database().reference()
let postsRef = database.child("posts")
let myPostCell = "myPostCell"
let blackList = database.child("blackList")
let afterLogin = "afterLogin"
let afterRegistration = "afterRegistration"
