//
//  Firebase Reference.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/14.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

let database = Database.database().reference()
let postsRef = database.child("posts")
