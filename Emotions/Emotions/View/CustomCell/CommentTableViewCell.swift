//
//  CommentTableViewCell.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/13.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    var post: Post?
    var comment: Comment?
    
    // comment detail cells
    @IBOutlet weak var commentUserNameLabel: UILabel!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentContentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(comment: Comment) {
        commentUserNameLabel.text = comment.userName
        commentDateLabel.text = dateToMakeDay(comment: comment) //코멘트용 함수 -> functions.swift 참고
        commentContentLabel.text = comment.content
    }
}
