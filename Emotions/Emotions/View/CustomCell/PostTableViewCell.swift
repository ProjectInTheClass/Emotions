//
//  PostTableViewCell.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/08.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    var delegate: PostCellDelegate?
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var firstCardLabel: UILabel!
    @IBOutlet weak var secondCardLabel: UILabel!
    @IBOutlet weak var thirdCardLabel: UILabel!
    @IBOutlet weak var leftDateLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeRoundedAndShadowed(view: cellBackgroundView)
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
    }
    
    func makeRoundedAndShadowed(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    
    // MARK: - IBAction

    @IBAction func heartButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.heartButtonTappedInCell(self, isSelected: sender.isSelected)
        print(indexPath)
    }
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.starButtonTappedInCell(self, isSelected: sender.isSelected)
        print(indexPath)
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        delegate?.commentButtonTappedInCell(self)
    }
    
    
}
