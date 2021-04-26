//
//  CommentTableViewCell.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/13.
//

import UIKit

class CommentTableViewCell: UITableViewCell {


    
    // comment detail cells
    @IBOutlet weak var commentUserNameLabel: UILabel!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentContentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    // 여기 수정은?
    func updateUI(comment: Comment) {
        textLabel?.text = comment.content
        detailTextLabel?.text = "\(comment.date)"
    }

}
