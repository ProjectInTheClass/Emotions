//
//  PostDetailViewController.swift
//  Emotions
//
//  Created by Jungsang Lim on 2021/04/26.
//

import UIKit

class PostDetailViewController: UIViewController {

    var post: Post?
    var comment: Comment?
    
    
    // post details
    @IBOutlet weak var firstCardBackgroundColorView: UIView!
    @IBOutlet weak var firstCardTitleLabel: UILabel!
    @IBOutlet weak var secondCardTitleLabel: UILabel?
    @IBOutlet weak var thirdCardTitleLabel: UILabel?
    @IBOutlet weak var postDdayLabel: UILabel!
    @IBOutlet weak var postContentTextView: UITextView!
    
    // comment post outlet and action
    @IBOutlet weak var commentBackgroundColorView: UIView!
    @IBOutlet weak var commentTextField: UITextField?
    @IBOutlet weak var commentPostButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
            postContentTextView.text = post.content
            
            firstCardTitleLabel.text = post.firstCard?.title
            secondCardTitleLabel?.text = post.secondCard?.title
            thirdCardTitleLabel?.text = post.thirdCard?.title
            
            postDdayLabel.text = dateToDday(post: post)
            
            firstCardBackgroundColorView.backgroundColor = post.firstCard?.cardType.typeBackground
        }
        
        updateUI()
        navigationConfigureUI()
    }
    
    
    // update UI func
    func updateUI() {
        guard let post = post else { return }
        if let firstCard = post.firstCard {
            firstCardTitleLabel.text = "#\(firstCard.title)"
            firstCardBackgroundColorView.backgroundColor = firstCard.cardType.typeBackground
        } else {
            firstCardTitleLabel.isHidden = true
            firstCardBackgroundColorView.isHidden = true
        }
        
    }
    
    
    
    
    // 코멘트 정보 가져오기
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        guard let post = post else { return }
//        CommentManager.shared.downloadComment(post: post) { success in
//            if success {
//                self.tableView.reloadData()
//            } else {
//
//            }
//        }
    }
    
    // navigation title 설정
    func navigationConfigureUI() {
        title = "Post Detail"
    }


}

 // MARK:- Comment Extention

// 댓글 리스트 커스텀셀 익스텐션
/*
extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return
        // commentCell
    }
 
}
    */
    
    

