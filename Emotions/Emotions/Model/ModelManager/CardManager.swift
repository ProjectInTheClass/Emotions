//
//  CardManager.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation
import UIKit

class CardManager {
    static let shared = CardManager()
    
    let cards: [Card] = [
        Card(title: "분노하는", image: UIImage(named: "01")!, cardType: .anger),
        Card(title: "불쾌한", image: UIImage(named: "02")!, cardType: .disgust),
        Card(title: "두려워하는", image: UIImage(named: "03")!, cardType: .fear),
        Card(title: "슬퍼하는", image: UIImage(named: "04")!, cardType: .sadness),
        Card(title: "기뻐하는", image: UIImage(named: "05")!, cardType: .joy),
        Card(title: "분노하는", image: UIImage(named: "01")!, cardType: .anger),
        Card(title: "불쾌한", image: UIImage(named: "02")!, cardType: .disgust),
        Card(title: "두려워하는", image: UIImage(named: "03")!, cardType: .fear),
        Card(title: "슬퍼하는", image: UIImage(named: "04")!, cardType: .sadness),
        Card(title: "기뻐하는", image: UIImage(named: "05")!, cardType: .joy),Card(title: "분노하는", image: UIImage(named: "01")!, cardType: .anger),
        Card(title: "불쾌한", image: UIImage(named: "02")!, cardType: .disgust),
        Card(title: "두려워하는", image: UIImage(named: "03")!, cardType: .fear),
        Card(title: "슬퍼하는", image: UIImage(named: "04")!, cardType: .sadness),
        Card(title: "기뻐하는", image: UIImage(named: "05")!, cardType: .joy),Card(title: "분노하는", image: UIImage(named: "01")!, cardType: .anger),
        Card(title: "불쾌한", image: UIImage(named: "02")!, cardType: .disgust),
        Card(title: "두려워하는", image: UIImage(named: "03")!, cardType: .fear),
        Card(title: "슬퍼하는", image: UIImage(named: "04")!, cardType: .sadness),
        Card(title: "기뻐하는", image: UIImage(named: "05")!, cardType: .joy),Card(title: "분노하는", image: UIImage(named: "01")!, cardType: .anger),
        Card(title: "불쾌한", image: UIImage(named: "02")!, cardType: .disgust),
        Card(title: "두려워하는", image: UIImage(named: "03")!, cardType: .fear),
        Card(title: "슬퍼하는", image: UIImage(named: "04")!, cardType: .sadness),
        Card(title: "기뻐하는", image: UIImage(named: "05")!, cardType: .joy)
    ]
}
