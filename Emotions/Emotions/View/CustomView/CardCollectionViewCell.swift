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
    
    
    override var isSelected: Bool {
        didSet {
            selectIndicator.isHidden = !isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardImage.contentMode = .scaleAspectFill
        cardImage.layer.masksToBounds = true
        cardImage.layer.cornerRadius = CornerRadius.myValue
        selectIndicator.layer.masksToBounds = true
        selectIndicator.layer.cornerRadius = selectIndicator.frame.height/2
       
    }
    
    func updateUI(card: Card) {
        cardImage.image = card.image
    }
}
