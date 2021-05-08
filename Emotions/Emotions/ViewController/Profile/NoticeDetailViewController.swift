//
//  NoticeDetailViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/05/08.
//

import UIKit

class NoticeDetailViewController: UIViewController {
    
    var notice: Notice?
    
    @IBOutlet weak var noticeTitle: UILabel!
    @IBOutlet weak var noticeDate: UILabel!
    @IBOutlet weak var noticeContent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        guard let notice = notice else { return }
        noticeTitle.text = notice.title
        noticeDate.text = notice.date
        noticeContent.text = notice.content
    }
}
