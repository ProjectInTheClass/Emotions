//
//  PostDetailViewController.swift
//  Emotions
//
//  Created by Jungsang Lim on 2021/04/26.
//

import UIKit
import FirebaseAuth

class PostDetailViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:- let & var
    
    //인스턴스 받아오기
    var post: Post?
    var comment: Comment?
    
    //MARK:- Outlets
    
    //table view
    @IBOutlet weak var tableView: UITableView!
    
    //post details - header view
    @IBOutlet weak var firstCardBackgroundColorView: UIView!
    @IBOutlet weak var firstCardTitleLabel: UILabel!
    @IBOutlet weak var secondCardTitleLabel: UILabel?
    @IBOutlet weak var thirdCardTitleLabel: UILabel?
    @IBOutlet weak var postDdayLabel: UILabel!
    @IBOutlet weak var postContentTextView: UITextView!
    @IBOutlet weak var postHeaderview: UIView!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var starPointLabel: UILabel!
    
    
    //comment post view - outlet (댓글게시 액션은 하단에)
    @IBOutlet weak var commentBackgroundColorView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentPostButton: UIButton!
    
    //MARK:- viewDidLoad & UI configure

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView Header register
        tableView.register(DetailHeaderView.self, forHeaderFooterViewReuseIdentifier: DetailHeaderView.reuseIdentifier)
        tableView.estimatedSectionHeaderHeight = view.frame.height / 2
        
        //tableview, textField declare
        tableView.delegate = self
        tableView.dataSource = self
        commentTextField?.delegate = self
        
        // textField 왼쪽(시작점)에 공백 주기
        commentTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        commentTextField.layer.cornerRadius = 15
        commentTextField.layer.borderWidth = 0.25
        commentTextField.layer.borderColor = UIColor.white.cgColor
        commentTextField.layer.shadowOpacity = 0.5
        commentTextField.layer.shadowRadius = 1.5
        commentTextField.layer.shadowOffset = CGSize.zero
        commentTextField.layer.shadowColor = UIColor.gray.cgColor
        
        //dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //keyboard returnKey Change -> done key
        commentTextField.returnKeyType = .done
        
        //if let shadowing, optional unwarpping
        //넘겨받은 post를 풀고, 그 post에 데이터가 있으면 아래를 수행
        //타입에 해당하는 인스턴스를 넣어준다
        if let post = post {
//            postContentTextView.text = post.content
//            firstCardTitleLabel.text = post.firstCard?.title
//            secondCardTitleLabel?.text = post.secondCard?.title
//            thirdCardTitleLabel?.text = post.thirdCard?.title
//            postDdayLabel.text = dateToDday(post: post)
//            starPointLabel.text = "\(post.starPoint)개"
//            firstCardBackgroundColorView.backgroundColor = post.firstCard?.cardType.typeColor
            commentBackgroundColorView.backgroundColor = post.firstCard?.cardType.typeBackground
        }
//        updateUI()
        navigationConfigureUI()
    }
 

    //MARK:- viewWillAppear - comment info download
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //코멘트 정보 다운로드
        guard let post = post else { return }
        CommentManager.shared.downloadComment(post: post) { [weak self] success in
            guard let self = self else { return }
            if success {
                print("코멘트 다운로드 성공")
                
                // 댓글 갯수 동기화
//                self.commentCountLabel.text = "\(CommentManager.shared.comments.count)개"
                
                // 코멘트 테이블뷰 동기화
                self.tableView.reloadData()
                
            } else {
                print("코멘트 다운로드 실패")
            }
        }
        
        // keyboard NotificationCender add
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //MARK:- viewWillDisappear - keyboard observer remove
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    //MARK:- Update UI func

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
            secondCardTitleLabel?.isHidden = false
        }
        
        //3번 카드
        if let thirdCard = post.thirdCard {
            thirdCardTitleLabel?.text = "#\(thirdCard.title)"
        } else {
            thirdCardTitleLabel?.isHidden = false
        }
    }
    
    
    
    //MARK:- navigation UI 설정
    
    func navigationConfigureUI() {
        title = "자세히 보기"
        navigationController?.navigationBar.tintColor = .darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "NanumSquareR", size: 15)!]
    }
    
    
    
    //MARK:- Scroll to Bottom Func
    func scrollToBottom() {
        guard CommentManager.shared.comments.count > 0 else { return }
        let lastRowInLastSection = CommentManager.shared.comments.count - 1
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: lastRowInLastSection, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    //MARK:- 댓글게시 button func

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
        
        // 댓글 게시 후 텍스트필드 클리어, 키보드 dismiss
        commentTextField.text = ""
        commentTextField.resignFirstResponder()
        
        // 하단 스크롤 함수
        scrollToBottom()
    }

    //MARK:- Keyboard control
    
    //코멘트 뷰 하단 레이아웃 제약 아울렛
    @IBOutlet weak var commentViewBottonConstraints: NSLayoutConstraint!
    
    //뷰 터치하면 키보드 내려가기
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //리턴 버튼 누르면 키보드 내려가기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardEndFrame.cgRectValue.height
        let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let margin: CGFloat = view.safeAreaInsets.bottom
        commentViewBottonConstraints.constant = 0
        
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.commentViewBottonConstraints.constant = margin - keyboardHeight
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardEndFrame.cgRectValue.height
        let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let margin: CGFloat = view.safeAreaInsets.bottom
        commentViewBottonConstraints.constant = keyboardHeight - margin
        
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.commentViewBottonConstraints.constant = 0
            self.view.layoutIfNeeded()
        }
    }

   
}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailHeaderView.reuseIdentifier) as? DetailHeaderView
        guard let post = post else { return nil }
        let comments = CommentManager.shared.comments
        header?.updateUI(post: post, comments: comments)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // 코멘트 테이블뷰 필수 메소드
    // 해당 글의 코멘트 수에 따라 셀 리턴 (섹션 내부의 셀 개수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentManager.shared.comments.count
    }
   
    // 셀 재활용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentDetailCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        let review = CommentManager.shared.comments[indexPath.row]
        cell.updateUI(comment: review)

        return cell
    }
}
