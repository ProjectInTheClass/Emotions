//
//  Card.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation
import UIKit

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
    
    
}
