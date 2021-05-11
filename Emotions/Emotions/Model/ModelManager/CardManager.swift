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
        Card(id: "1", title: "감동적인", image: UIImage(named: "01")!, cardType: .joy, isSelected: false),
        Card(id: "2",title: "감사한", image: UIImage(named: "02")!, cardType: .joy, isSelected: false),
        Card(id: "3",title: "기쁜", image: UIImage(named: "03")!, cardType: .joy, isSelected: false),
        Card(id: "4",title: "재미있는", image: UIImage(named: "04")!, cardType: .joy, isSelected: false),
        Card(id: "5",title: "사랑스러운", image: UIImage(named: "05")!, cardType: .joy, isSelected: false),
        Card(id: "6",title: "괴로운", image: UIImage(named: "06")!, cardType: .sadness, isSelected: false),
        Card(id: "7",title: "미안한", image: UIImage(named: "07")!, cardType: .sadness, isSelected: false),
        Card(id: "8",title: "슬픈", image: UIImage(named: "08")!, cardType: .sadness, isSelected: false),
        Card(id: "9",title: "외로운", image: UIImage(named: "09")!, cardType: .sadness, isSelected: false),
        Card(id: "10",title: "서운한", image: UIImage(named: "10")!, cardType: .sadness, isSelected: false),
        Card(id: "11",title: "걱정스러운", image: UIImage(named: "11")!, cardType: .fear, isSelected: false),
        Card(id: "12",title: "당황한", image: UIImage(named: "12")!, cardType: .fear, isSelected: false),
        Card(id: "13",title: "두려운", image: UIImage(named: "13")!, cardType: .fear, isSelected: false),
        Card(id: "14",title: "무서운", image: UIImage(named: "14")!, cardType: .fear, isSelected: false),
        Card(id: "15",title: "긴장한", image: UIImage(named: "15")!, cardType: .fear, isSelected: false),
        Card(id: "16",title: "답답한", image: UIImage(named: "16")!, cardType: .anger, isSelected: false),
        Card(id: "17",title: "미운", image: UIImage(named: "17")!, cardType: .anger, isSelected: false),
        Card(id: "18",title: "분한", image: UIImage(named: "18")!, cardType: .anger, isSelected: false),
        Card(id: "19",title: "억울한", image: UIImage(named: "19")!, cardType: .anger, isSelected: false),
        Card(id: "20",title: "짜증나는", image: UIImage(named: "20")!, cardType: .anger, isSelected: false),
        Card(id: "21",title: "귀찮은", image: UIImage(named: "21")!, cardType: .disgust, isSelected: false),
        Card(id: "22",title: "부끄러운", image: UIImage(named: "22")!, cardType: .disgust, isSelected: false),
        Card(id: "23",title: "부러운", image: UIImage(named: "23")!, cardType: .disgust, isSelected: false),
        Card(id: "24",title: "불쾌한", image: UIImage(named: "24")!, cardType: .disgust, isSelected: false),
        Card(id: "25",title: "피곤한", image: UIImage(named: "25")!, cardType: .disgust, isSelected: false)
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
