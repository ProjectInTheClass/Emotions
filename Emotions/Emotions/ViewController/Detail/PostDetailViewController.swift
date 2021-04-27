//
//  PostDetailViewController.swift
//  Emotions
//
//  Created by Jungsang Lim on 2021/04/26.
//

import UIKit
import FirebaseAuth

class PostDetailViewController: UIViewController, UITextFieldDelegate {

    var post: Post?
    var comment: Comment?
    
    var detailCompletionHandler: (()->Void)?
    
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
        
        commentTextField?.returnKeyType = .done
        
        commentTextField?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
        
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
      
            
            
        }
        
        //commentBackgroundColorView.delegate = self
        
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            commentBackgroundColorView.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            commentBackgroundColorView.frame.origin.y += keyboardHeight
        }
    }
        

    func endEditing() {
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
        
        //2번 카드
        if let secondCard = post.secondCard {
            secondCardTitleLabel?.text = "#\(secondCard.title)"
        } else {
            secondCardTitleLabel?.isHidden = true
        }
        
        //3번 카드
        if let thirdCard = post.thirdCard {
            thirdCardTitleLabel?.text = "#\(thirdCard.title)"
        } else {
            thirdCardTitleLabel?.isHidden = true
        }
        
    }
    
    // navigation title 설정
    func navigationConfigureUI() {
        title = "Post Detail Test"
    }
    
    
    // 댓글쓰기 버튼 함수
    @IBAction func commentPost(_ sender: UIButton) {
        print("comment Upload Complete")
        
        guard let post = post,
              let userName = Auth.auth().currentUser?.displayName,
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
    
    // 텍스트필드 키보드 제어 함수 (작동 안함)
    /*
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { self.view.endEditing(true) }
    */
    
    
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
                print("코멘트 다운로드 성공")
                
                // 리로드 방법?
                // self.tableview.reloadData() 와 같은 메소드를 넣을 수 없음
                //print("코멘트 리로드 성공")
            } else {
                print("코멘트 다운로드 실패")
        }
    }
}
}



// 코멘트 테이블뷰 익스텐션
extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
        
    // 해당 글의 코멘트 수에 따라 셀 리턴 (섹션 내부의 셀 개수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentManager.shared.comments.count
    }
    

    
    // 셀 재활용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reuseID 대입, 커스텀셀 캐스팅
        let comments = CommentManager.shared.comments[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentDetailCell") as? CommentTableViewCell else { return UITableViewCell() }
    
        // update custom cell UI
        
        cell.commentUserNameLabel.text = comments.userName
        cell.commentDateLabel.text = "\(dateToMakeDay(comment: comments))"
        cell.commentContentLabel.text = comments.content

    
//        let comment = CommentManager.shared.comments[indexPath.row]
//        cell.updateUI(comment: comment)
    
        return cell
    }
}

