//
//  AddPostViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/10.
//

import UIKit

class AddPostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var selectCardButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        navigationConfigureUI()
        registerForNotifications()
        contentTextView.delegate = self
        contentTextView.text = "고른 감정에 대해 이야기해주세요:)"
        contentTextView.textColor = UIColor.lightGray
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
    
    func configureUI() {
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
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "AppleColorEmoji", size: 21)!]
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
