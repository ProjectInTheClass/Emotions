//
//  CommentTableViewCell.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/13.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    // 코멘트 커스텀셀 아울렛 생성
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
