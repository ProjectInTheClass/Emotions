//
//  PostTableViewCell.swift
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
    @IBOutlet var buttons: [UIButton]!
    
    var heartButtonCompletion: ((Bool)->Void)?
    var starButtonCompletion: ((Bool)->Void)?
    var commentButtonCompletion: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeRoundedAndShadowed(view: cellBackgroundView)
        buttons.forEach { button in
            button.addTarget(self, action: #selector(buttonsTapped(_:)), for: .touchUpInside)
        }
    }
    
    func updateUI(post: Post, comments: [Comment]) {
        let attributedString = NSMutableAttributedString(string: post.content)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        postContentLabel.attributedText = attributedString
        firstCardLabel.text = "#\(post.firstCard.title)"
        firstCardLabel.textColor = post.firstCard.cardType.typeColor
        secondCardLabel.text = "#\(post.secondCard.title)"
        secondCardLabel.textColor = post.secondCard.cardType.typeColor
        thirdCardLabel.text = "#\(post.thirdCard.title)"
        thirdCardLabel.textColor = post.thirdCard.cardType.typeColor
        heartButton.setState(post.isHeart)
        starButton.setState(post.isGood)
    }
    
    func makeRoundedAndShadowed(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.shadowColor = UIColor.lightGray.cgColor
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
        default:
            break
        }
    }
    
}
