//
//  CommentTableViewCell.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/13.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func updateUI(comment: Comment) {
        textLabel?.text = comment.content
        detailTextLabel?.text = "\(comment.date)"
    }

}
