//
//  Constants.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/17.
//

import Foundation
import Firebase

let database = Database.database().reference()
let postsRef = database.child("posts")
let commentRef = database.child("comments")
let blackList = database.child("blackList")

let joyLottie = "21930-selectdavid"
let angerLottie = "28759-angry-emoji"

let joyBGColor = "joyBG"
let sadnessBGColor = "sadnessBG"

let joyColor = "joy"
let sadnessColor = "sadness"
let angerColor = "anger"
let disgustColor = "disgust"
let fearColor = "fear"

let logoImage = "logoImage"
let InfoCircle = "Info Circle"
let emotionDeepGreen = "emotionDeepGreen"
let emotionLightGreen = "emotionLightGreen"
let emotionDeepPink = "emotionDeepPink"
let emotionLightPink = "emotionLightPink"
let postCell = "postCell"
let myPostCell = "myPostCell"
let afterLogin = "afterLogin"
let afterRegistration = "afterRegistration"
