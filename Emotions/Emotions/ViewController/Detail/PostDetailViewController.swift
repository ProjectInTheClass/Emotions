//
//  PostDetailViewController.swift
//  Emotions
//
//  Created by Jungsang Lim on 2021/04/26.
//

import UIKit
import FirebaseAuth

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    

    
    
    //MARK:- let & var
    
    //인스턴스 받아오기
    var post: Post?
    var comment: Comment?
    
    //컴플리션핸들러 : 현재 미사용
    var detailCompletionHandler: (()->Void)?
    
    
    
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
    
    //comment post view - outlet (댓글게시 액션은 하단에)
    @IBOutlet weak var commentBackgroundColorView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentPostButton: UIButton!
    

    
    //MARK:- viewDidLoad & UI configure

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableview, textField declare
        tableView.delegate = self
        tableView.dataSource = self
        commentTextField?.delegate = self
        
        //UI configure
        firstCardBackgroundColorView.layer.cornerRadius = 30
        
        // textField 왼쪽(시작점)에 공백 주기
        commentTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        commentTextField.layer.cornerRadius = 15
        commentTextField.layer.borderWidth = 0.25
        commentTextField.layer.borderColor = UIColor.white.cgColor
        commentTextField.layer.shadowOpacity = 0.5
        commentTextField.layer.shadowRadius = 1.5
        commentTextField.layer.shadowOffset = CGSize.zero
        commentTextField.layer.shadowColor = UIColor.gray.cgColor
        
//        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: commentTextField.frame.height))
//        commentTextField.leftView = paddingView
        
        
        //dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //keyboard returnKey Change -> done key
        commentTextField.returnKeyType = .done
        
        
        //if let shadowing, optional unwarpping
        //넘겨받은 post를 풀고, 그 post에 데이터가 있으면 아래를 수행
        //타입에 해당하는 인스턴스를 넣어준다
        if let post = post {
            postContentTextView.text = post.content
            
            firstCardTitleLabel.text = post.firstCard?.title
            secondCardTitleLabel?.text = post.secondCard?.title
            thirdCardTitleLabel?.text = post.thirdCard?.title
            
            postDdayLabel.text = dateToDday(post: post)
            
            firstCardBackgroundColorView.backgroundColor = post.firstCard?.cardType.typeBackground
            commentBackgroundColorView.backgroundColor = post.firstCard?.cardType.typeBackground
        }
        
        updateUI()
        navigationConfigureUI()
        

        
        //keyboard notification center
        //옵저버 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            
        //옵저버 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
        

    //MARK:- viewWillAppear - comment info download
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //코멘트 정보 다운로드
        guard let post = post else { return }
        CommentManager.shared.downloadComment(post: post) { success in
            if success {
                print("코멘트 다운로드 성공")
                self.tableView.reloadData()
                print("코멘트 리로드 성공")
            } else {
                print("코멘트 다운로드 실패")
            }
        }
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
            secondCardTitleLabel?.isHidden = true
        }
        
        //3번 카드
        if let thirdCard = post.thirdCard {
            thirdCardTitleLabel?.text = "#\(thirdCard.title)"
        } else {
            thirdCardTitleLabel?.isHidden = true
        }
    }
    
    //MARK:- navigation title 설정
    
    func navigationConfigureUI() {
        title = "자세히보기"
    }
    
    
    
    //MARK:- 댓글게시 btn func

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
    
    
    
    //MARK:- Keyboard control
    
    //코멘트 뷰 하단 레이아웃 제약 아울렛
    @IBOutlet weak var commentBottonConstraints: NSLayoutConstraint!
    
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
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            commentBackgroundColorView.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            commentBackgroundColorView.frame.origin.y += keyboardHeight
        }
    }

        

    //MARK:- Table View Data Source
    
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
