//
//  CardCollectionViewCell.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/11.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var selectIndicator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardImage.contentMode = .scaleAspectFill
        cardImage.layer.masksToBounds = true
        cardImage.layer.cornerRadius = CornerRadius.myValue + 18
    }
    
    func updateUI(card: Card) {
        cardImage.image = card.image
        selectIndicator.isHidden = !card.isSelected
    }
}
