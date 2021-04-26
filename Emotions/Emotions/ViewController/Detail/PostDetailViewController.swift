//
//  PostDetailViewController.swift
//  Emotions
//
//  Created by Jungsang Lim on 2021/04/26.
//

import UIKit

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    
    
    // 댓글쓰기 버튼 함수
    @IBAction func commentPost(_ sender: UIButton) {
        print("comment Upload Complete")
        
        guard let post = post,
              let userName = AuthManager.shared.currentUser?.displayName,
              let content = commentTextField?.text else {
            print("내용을 입력해 주세요.")
            return }
        
        let reviewDictionary:[String:Any] = [
            "postID": post.postID,
            "userName": userName,
            "userEmail": post.userEmail,
            "content": content,
            "date": Int(Date().timeIntervalSince1970)
        ]
        
        CommentManager.uploadComment(dictionary: reviewDictionary)
    }
    
    
//    func reloadRows(at indexPaths: [IndexPath],
//                    with animation: UITableView.RowAnimation) {
//       // cell.commentDateLabel.text = "\(dateToMakeDay(comment: comment))"
//       // cell.commentContentLabel.text = comment.content
//       // cell.updateUI(comment: comment)
//    }
    
    // 코멘트 정보 가져오기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let post = post else { return }
        CommentManager.shared.downloadComment(post: post) { success in
            if success {
                print("코멘트 리로드 성공")
                // 리로드 방법?
                // self.tableview.reloadData() 와 같은 메소드를 넣을 수 없음
            } else {
                print("코멘트 리로드 실패")
            }
        }
    }
    
    // navigation title 설정
    func navigationConfigureUI() {
        title = "Post Detail"
    }
    
    
    // 섹션의 개수 (기본 1개)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 해당 글의 코멘트 수에 따라 셀 리턴
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentManager.shared.comments.count
    }
    
    // 셀 재활용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // reuseID 대입, 커스텀셀 캐스팅
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        
            // 유저네임, 날짜, 댓글내용 대입
            let comment = CommentManager.shared.comments[indexPath.row]
            cell.commentUserNameLabel.text = comment.userName
            cell.commentDateLabel.text = "\(dateToMakeDay(comment: comment))"
            cell.commentContentLabel.text = comment.content
            cell.updateUI(comment: comment)
        
            return cell
    }
    


}

 // MARK:- Comment Extention

/*
// 댓글 리스트 커스텀셀 익스텐션

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    // 섹션의 개수 (기본 1개)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 해당 글의 코멘트 수에 따라 셀 리턴
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentManager.shared.comments.count
    }
    
    // 셀 재활용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // reuseID 대입, 커스텀셀 캐스팅
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        
            // 유저네임, 날짜, 댓글내용 대입
            let comment = CommentManager.shared.comments[indexPath.row]
            cell.commentUserNameLabel.text = comment.userName
            cell.commentDateLabel.text = "\(dateToMakeDay(comment: comment))"
            cell.commentContentLabel.text = comment.content
            cell.updateUI(comment: comment)
        
            return cell
    }
    
    // 셀 밀어서 삭제하기 구현
}
*/
