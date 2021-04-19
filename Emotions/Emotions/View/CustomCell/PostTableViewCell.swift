//
//  LatestTableViewCell.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/08.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var firstCardLabel: UILabel!
    @IBOutlet weak var secondCardLabel: UILabel!
    @IBOutlet weak var thirdCardLabel: UILabel!
    @IBOutlet weak var leftDateLabel: UILabel!
    @IBOutlet weak var heartButton: HeartButton!
    @IBOutlet weak var starButton: StarButton!
    @IBOutlet weak var commentButton: CommentButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    
    var heartButtonCompletion: ((Bool)->Void)?
    var starButtonCompletion: ((Bool)->Void)?
    var commentButtonCompletion: (()->Void)?
    var reportButtonCompletion: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeRoundedAndShadowed(view: cellBackgroundView)
        buttons.forEach { button in
            button.addTarget(self, action: #selector(buttonsTapped(_:)), for: .touchUpInside)
        }
//        firstCardLabel.layer.masksToBounds = true
//        firstCardLabel.layer.cornerRadius = 15
//        secondCardLabel.layer.masksToBounds = true
//        secondCardLabel.layer.cornerRadius = 15
//        thirdCardLabel.layer.masksToBounds = true
//        thirdCardLabel.layer.cornerRadius = 15
    }
    
    func updateUI(post: Post, comments: [Comment]) {
        if let firstCard = post.firstCard {
            firstCardLabel.text = "#\(firstCard.title)"
            firstCardLabel.textColor = firstCard.cardType.typeColor
            firstCardLabel.isHidden = false
        } else {
            firstCardLabel.isHidden = true
        }
        
        if let secondCard = post.secondCard {
            secondCardLabel.text = "#\(secondCard.title)"
            secondCardLabel.textColor = secondCard.cardType.typeColor
            secondCardLabel.isHidden = false
        } else {
            secondCardLabel.isHidden = true
        }
        
        if let thirdCard = post.thirdCard {
            thirdCardLabel.text = "#\(thirdCard.title)"
            thirdCardLabel.textColor = thirdCard.cardType.typeColor
            thirdCardLabel.isHidden = false
        } else {
            thirdCardLabel.isHidden = true
        }
      
        let attributedString = NSMutableAttributedString(string: post.content)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        postContentLabel.attributedText = attributedString
        heartButton.setState(post.isHeart)
        starButton.setState(post.isStar)
        leftDateLabel.text = dateToDday(post: post)
    }
    
    func makeRoundedAndShadowed(view: UIView) {
        view.layer.cornerRadius = 6
        view.layer.shadowColor = UIColor.opaqueSeparator.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    
    @objc func buttonsTapped(_ sender: UIButton) {
        switch sender {
        case heartButton:
            if let heartButtonCompletion = heartButtonCompletion {
                heartButtonCompletion(heartButton.isActivated)
            }
        case starButton:
            if let starButtonCompletion = starButtonCompletion {
                starButtonCompletion(starButton.isActivated)
            }
        case commentButton:
            if let commentButtonCompletion = commentButtonCompletion {
                commentButtonCompletion()
            }
        case reportButton:
            if let reportButtonCompletion = reportButtonCompletion {
                reportButtonCompletion()
            }
        default:
            break
        }
    }
    
}
