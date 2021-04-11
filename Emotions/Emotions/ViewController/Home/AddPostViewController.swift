//
//  AddPostViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/10.
//

import UIKit
import PanModal

class AddPostViewController: UIViewController, UITextViewDelegate {
    
    var selectedCards: [Card]?
    
    @IBOutlet weak var selectCardButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addTargetButton()
        navigationConfigureUI()
        registerForNotifications()
        
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
        cardCollectionVC.completionHandler = { selectedCards in
            self.selectedCards = selectedCards
        }
    }
    
    @objc func uploadButtonTapped() {
        print("uploade Button Tapped")
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - UI and UserInteraction Functions
    func configureUI() {
        contentTextView.delegate = self
        contentTextView.text = "고른 감정에 대해 이야기해주세요:)"
        contentTextView.textColor = UIColor.lightGray
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        dateLabel.text = formatter.string(from: Date())
        selectCardButton.layer.masksToBounds = true
        selectCardButton.layer.cornerRadius = 8
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 8
    }

    func navigationConfigureUI() {
        title = "Post"
        navigationController?.navigationBar.tintColor = .darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "AppleColorEmoji", size: 21)!]
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
        if textView.textColor == UIColor.lightGray { textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "고른 감정에 대해 이야기해주세요:)"
            textView.textColor = UIColor.lightGray
        }
    }
}
