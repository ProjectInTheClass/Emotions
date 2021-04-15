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
    
    var posts: [Post] = []
    
    // 우리가 필요한 데이터 목록
    // 1. 최신순으로 정렬된 posts
    // 2. 최근 한 달의 감정카드 타입 목록
    // 3. 그 타입으로 정렬된 posts
    // 4. starPoint순으로 정렬된 posts
    // 5. 나의 글만 보여주는 posts
    // 6. 내가 좋아요를 누른 글만 보여주는 posts
    
    // 1. firebase형식의 모델로 전환 - 완료
    // 2. 모델의 각 프로퍼티별 서버와 인터렉션 방식 설정
    // 3. 필요한 database ref 정리
    // 4. CRUD 설정
    // 5. 프로젝트에 적용

}
