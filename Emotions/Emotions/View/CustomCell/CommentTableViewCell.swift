//
//  CommentTableViewCell.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/13.
//

import UIKit
import Kingfisher
import FirebaseAuth

class CommentTableViewCell: UITableViewCell {

    var post: Post?
    var comment: Comment?
    var deleteComment: (()->Void)?
    
    // comment detail cells
    @IBOutlet weak var commentUserNameLabel: UILabel!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentContentLabel: UILabel!
    @IBOutlet weak var commentUserImage: UIImageView!
    @IBOutlet weak var deleteCommentButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentUserImage.layer.masksToBounds = true
        commentUserImage.layer.cornerRadius = commentUserImage.frame.height / 2
    }

    func updateUI(comment: Comment) {
        if comment.userEmail == Auth.auth().currentUser?.email {
            deleteCommentButton.isHidden = false
        } else {
            deleteCommentButton.isHidden = true
        }
        commentUserNameLabel.text = comment.userName
        commentDateLabel.text = dateToMakeDay(comment: comment) //코멘트용 함수 -> functions.swift 참고
        commentContentLabel.text = comment.content
        commentUserImage.kf.setImage(with: URL(string: comment.imageURL), options: [.forceRefresh])
    }
    
    @IBAction func deleteCommentButton(_ sender: UIButton) {
        if let deleteComment = deleteComment {
            deleteComment()
        }
    }
    
}
