//
//  Card.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation
import UIKit

struct Card {
    var title: String
    var image: UIImage
    var cardType: CARDTYPE
}

enum CARDTYPE {
    case joy
    case sadness
    case anger
    case disgust
    case fear
    
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
}
