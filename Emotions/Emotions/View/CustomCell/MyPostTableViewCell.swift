//
//  MyPostTableViewCell.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/18.
//

import UIKit

class MyPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstCardImage: UIImageView!
    @IBOutlet weak var secondCardImage: UIImageView!
    @IBOutlet weak var thirdCardImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(post: Post) {
        firstCardImage.layer.masksToBounds = true
        firstCardImage.layer.cornerRadius = firstCardImage.frame.height / 2
        secondCardImage.layer.masksToBounds = true
        secondCardImage.layer.cornerRadius = secondCardImage.frame.height / 2
        thirdCardImage.layer.masksToBounds = true
        thirdCardImage.layer.cornerRadius = thirdCardImage.frame.height / 2
        firstCardImage.image = post.firstCard?.image
        secondCardImage.image = post.secondCard?.image
        thirdCardImage.image = post.thirdCard?.image
        dateLabel.text = dateToDdayForMyPost(post: post)
    }

}
