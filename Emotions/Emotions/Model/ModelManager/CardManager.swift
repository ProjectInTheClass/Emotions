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
        Card(id: "1", title: "분노하는", image: UIImage(named: "01")!, cardType: .anger, isSelected: false),
        Card(id: "2",title: "불쾌한", image: UIImage(named: "02")!, cardType: .disgust, isSelected: false),
        Card(id: "3",title: "두려워하는", image: UIImage(named: "03")!, cardType: .fear, isSelected: false),
        Card(id: "4",title: "슬퍼하는", image: UIImage(named: "04")!, cardType: .sadness, isSelected: false),
        Card(id: "5",title: "기뻐하는", image: UIImage(named: "05")!, cardType: .joy, isSelected: false)
    ]
    
    func fetchJoyCards(cards: [Card]) -> [Card] {
        let joyCards = cards.filter { $0.cardType == .joy }
        return joyCards
    }
    
    func fetchSadnessCards(cards: [Card]) -> [Card] {
        let sadnessCards = cards.filter { $0.cardType == .sadness }
        return sadnessCards
    }
    
    func fetchAngerCards(cards: [Card]) -> [Card] {
        let angerCards = cards.filter { $0.cardType == .anger }
        return angerCards
    }
    
    func fetchDisgustCards(cards: [Card]) -> [Card] {
        let disgustCards = cards.filter { $0.cardType == .disgust }
        return disgustCards
    }
    
    func fetchFearCards(cards: [Card]) -> [Card] {
        let fearCards = cards.filter { $0.cardType == .fear }
        return fearCards
    }
    
    func searchCardByID(cardID: String) -> Card? {
        guard let card = cards.filter({ $0.id  == cardID }).first else { return nil }
        
        return card
    }
    
}
