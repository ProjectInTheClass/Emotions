//
//  Card.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation
import UIKit
import Lottie

class Card {
    var id: String
    var title: String
    var image: UIImage
    var cardType: CARDTYPE
    var isSelected: Bool
    
    init(id: String, title: String, image: UIImage, cardType: CARDTYPE, isSelected: Bool) {
        self.id = id
        self.title = title
        self.cardType = cardType
        self.isSelected = isSelected
        self.image = image
    }
}

enum CARDTYPE : String {
    case joy = "joy"
    case sadness = "sadness"
    case anger = "anger"
    case disgust = "disgust"
    case fear = "fear"
    
    var typeColor: UIColor {
        switch self {
        case .joy: return UIColor(named: "joy")!
        case .sadness: return UIColor(named: "sadness")!
        case .anger: return UIColor(named: "anger")!
        case .disgust: return UIColor(named: "disgust")!
        case .fear: return UIColor(named: "fear")!
        }
    }
    
    var typeTitle: String {
        switch self {
        case .joy: return "기쁨"
        case .sadness: return "슬픔"
        case .anger: return "분노"
        case .disgust: return "불쾌"
        case .fear: return "두려움"
        }
    }
    
    var typeBackground: UIColor {
        switch self {
        case .joy: return UIColor(named: "joyBG")!
        case .sadness: return UIColor(named: "sadnessBG")!
        case .anger: return UIColor(named: "angerBG")!
        case .disgust: return UIColor(named: "disgustBG")!
        case .fear: return UIColor(named: "fearBG")!
        }
    }
    
//    var typeLottieImage: LottieView {
//        switch self {
//        case .joy: return
//        case .sadness: return
//        case .anger: return
//        case .disgust: return
//        case .fear: return
//        }
//    }
    
    var typeString: String {
        switch self {
        case .joy: return "지난 한 달간 기쁜 일이 많으셨군요!\n기쁜 감정들을 나눠주세요!"
        case .sadness: return "지난 한 달간 슬픈 일이 많으셨군요ㅠ\n슬픈 감정들을 돌아보며 정리해보는건 어떨까요?"
        case .anger: return "지난 한 달간 화가나는 일이 많으셨군요.\n분노의 감정을 차근차근 돌아보며 정리해봐요"
        case .disgust: return "지난 한 달간 불쾌한 일이 많으셨군요.\n무슨 일이셨나요? 함께 나눠주세요."
        case .fear: return "지난 한 달간 두려운 일이 많으셨군요.\n두려웠던 이야기를 나눠주세요."
        }
    }
    
}
