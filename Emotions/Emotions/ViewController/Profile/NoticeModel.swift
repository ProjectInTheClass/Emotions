//
//  NoticeModel.swift
//  Emotions
//
//  Created by 박형석 on 2021/05/08.
//

import Foundation

struct Notice {
    var title: String
    var content: String
    var date: String = stringToDate(date: Date())
}

struct NoticeManager {
    static let notices = [Notice(title: "[공지] 감정들 운영정책 안내",
                                 content: "안녕하세요? 감정들입니다. 저희 서비스를 이용해 주시는 회원 여러분께 감사드리며, 감정들 운영 정책에 관해 안내드립니다.\n\n# 포스팅\n\n감정카드를 선택하고 해당 감정카드에 대한 글을 적어올리시면, 30일간 유지되는 포스팅을 공유하게 됩니다. 포스팅은 공감하기, 추천하기, 댓글달기 버튼이 있습니다. 각 버튼은 사용자 활동의 데이터로 사용되고 추천 글, 감정 통계 등에 사용됩니다. 또한 신고하기 버튼으로 사용자들의 자발적인 참여로 게시판이 깨끗하게 관리됩니다. 마지막으로 모든 포스팅은 철저한 익명성과 함께 30일 이후 모든 데이터베이스에 삭제됩니다.\n\n# 감정 통계와 감정 관리\n\n조금 더 적극적으로 감정을 관리하실 수 있습니다. 내 글 탭에서 내가 기록했던 감정들을 정리할 수 있고, 감정 통계에서는 내가 활동했던 정보를 기반으로 지난 한 달간의 내 감정을 돌아볼 수 있습니다. ")]
}
