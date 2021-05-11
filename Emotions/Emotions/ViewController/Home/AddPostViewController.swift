//
//  AddPostViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/10.
//

import UIKit
import PanModal
import FirebaseAuth

class AddPostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var selectCardButton: UIButton!
    @IBOutlet weak var secondCardImage: UIImageView!
    @IBOutlet weak var thirdCardImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    
    
    var selectedCards: [Card]? {
        didSet {
            if let selectedCards = selectedCards {
                backgroundView.backgroundColor = selectedCards[0].cardType.typeBackground
            }
        }
    }
    
    var handle: AuthStateDidChangeListenerHandle?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addTargetButton()
        navigationConfigureUI()
        registerForNotifications()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if auth.currentUser == nil {
                self.user = nil
            } else {
                self.user = auth.currentUser
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: - Ability Functions
    
    func addTargetButton() {
        selectCardButton.addTarget(self, action: #selector(selectCardButtonTapped), for: .touchUpInside)
        uploadButton.target = self
        uploadButton.action = #selector(uploadButtonTapped)
    }
    
    @objc func selectCardButtonTapped() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let cardCollectionVC = storyboard.instantiateViewController(withIdentifier: "cardCollectionVC") as? CardCollectionViewController else { return }
        cardCollectionVC.modalPresentationStyle = .automatic
        presentPanModal(cardCollectionVC)
        
        cardCollectionVC.completionHandler = { [weak self]
            selectedCards in
            guard let self = self else { return }
            self.selectedCards = selectedCards
            
            switch selectedCards.count {
            case 1:
                self.selectCardButton.setImage(selectedCards[0].image, for: .normal)
                self.secondCardImage.isHidden = true
                self.thirdCardImage.isHidden = true
            case 2:
                self.selectCardButton.setImage(selectedCards[0].image, for: .normal)
                self.secondCardImage.image = selectedCards[1].image
                self.secondCardImage.isHidden = false
                self.thirdCardImage.isHidden = true
            case 3:
                self.selectCardButton.setImage(selectedCards[0].image, for: .normal)
                self.secondCardImage.image = selectedCards[1].image
                self.thirdCardImage?.image = selectedCards[2].image
                self.secondCardImage.isHidden = false
                self.thirdCardImage.isHidden = false
            default:
                break
            }
        }
    }
    
    @objc func uploadButtonTapped() {
        guard let user = user else { return }
        
        var firstCard: Card?
        var secondCard: Card?
        var thirdCard: Card?
        
        if let selectedCards = self.selectedCards, !selectedCards.isEmpty {
            if selectedCards.count == 1 {
                firstCard = selectedCards[0]
            } else if selectedCards.count == 2 {
                firstCard = selectedCards[0]
                secondCard = selectedCards[1]
            } else {
                firstCard = selectedCards[0]
                secondCard = selectedCards[1]
                thirdCard = selectedCards[2]
            }
        } else {
            print("카드를 선택해주세요.")
            return
        }
        
        guard let content = self.contentTextView.text,
              content != "고른 감정에 대해 이야기해주세요:)" else {
            print("내용을 적어주세요.")
            return
        }
        
        guard let afterAMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date()) else { return }
        let endDate = Int(afterAMonth.timeIntervalSince1970)
        let postkey = UUID().uuidString
        let dataDictionary: [String:Any] = [
            "postID":postkey,
            "userEmail":user.email!,
            "content":content,
            "endDate":endDate,
            "firstCardID":firstCard?.id ?? "0",
            "secondCardID":secondCard?.id ?? "0",
            "thirdCardID":thirdCard?.id ?? "0",
            "starPoint":0,
            "heartUser":[:],
            "starUser":[:],
            "userID":user.uid
        ]
        
        let myPost = Post(currentUserUID: user.uid, dictionary: dataDictionary)
        if let firstCardID = dataDictionary["firstCardID"] as? String {
            myPost.firstCard = CardManager.shared.searchCardByID(cardID: firstCardID)
        }
        if let secondCardID = dataDictionary["secondCardID"] as? String {
            myPost.secondCard = CardManager.shared.searchCardByID(cardID: secondCardID)
        }
        if let thirdCardID = dataDictionary["thirdCardID"] as? String {
            myPost.thirdCard = CardManager.shared.searchCardByID(cardID: thirdCardID)
        }
        PostManager.shared.userPosts.append(myPost)
        postsRef.child(postkey).setValue(dataDictionary)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UI and UserInteraction Functions
    func configureUI() {
        contentTextView.delegate = self
        contentTextView.text = "고른 감정에 대해 이야기해주세요:)"
        contentTextView.textColor = UIColor.darkGray
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        dateLabel.text = formatter.string(from: Date())
        selectCardButton.layer.masksToBounds = true
        selectCardButton.layer.cornerRadius = 8
        secondCardImage?.layer.masksToBounds = true
        secondCardImage?.layer.cornerRadius = 8
        thirdCardImage?.layer.masksToBounds = true
        thirdCardImage?.layer.cornerRadius = 8
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 8
    }
    
    func navigationConfigureUI() {
        title = "글 올리기"
        navigationController?.navigationBar.tintColor = .darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "NanumSquareR", size: 17)!]
    }
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWasShown(notification:)), name:UIResponder.keyboardWillShowNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillBeHidden(notification:)), name:UIResponder.keyboardWillHideNotification, object:nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo
        if let keyboardRect = info?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardSize = keyboardRect.size
            let contentInset = UIEdgeInsets(
                top: 0.0,
                left: 0.0,
                bottom: keyboardSize.height,
                right: 0.0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray { textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "고른 감정에 대해 이야기해주세요:)"
            textView.textColor = UIColor.darkGray
        }
    }
}
