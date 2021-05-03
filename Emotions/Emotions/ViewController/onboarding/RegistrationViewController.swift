//
//  RegistrationViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/14.
//

import UIKit
import TransitionButton

class RegistrationViewController: UIViewController {
    
    //MARK: -Outlet
    
    @IBOutlet weak var registrationEmailTextField: UITextField!
    @IBOutlet weak var registrationNickNameTextField: UITextField!
    @IBOutlet weak var registrationPasswordTextField: UITextField!
    @IBOutlet weak var registrationPasswordCheckTextField: UITextField!
    @IBOutlet weak var signUpButton: TransitionButton!
    
    @IBOutlet weak var middleConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackview: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateTransitionUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registrationEmailTextField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(willShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - UI Update
    
    private func updateUI() {
        registrationEmailTextField.delegate = self
        registrationNickNameTextField.delegate = self
        registrationPasswordTextField.delegate = self
        registrationPasswordCheckTextField.delegate = self
        
        registrationEmailTextField.layer.masksToBounds = true
        registrationEmailTextField.layer.cornerRadius = CornerRadius.myValue
        registrationEmailTextField.attributedPlaceholder = NSAttributedString(text: "이메일", aligment: .left, color: .lightGray)
        
        registrationNickNameTextField.layer.masksToBounds = true
        registrationNickNameTextField.layer.cornerRadius = CornerRadius.myValue
        registrationNickNameTextField.attributedPlaceholder = NSAttributedString(text: "닉네임", aligment: .left, color: .lightGray)
        
        registrationPasswordTextField.layer.masksToBounds = true
        registrationPasswordTextField.layer.cornerRadius = CornerRadius.myValue
        registrationPasswordTextField.attributedPlaceholder = NSAttributedString(text: "비밀번호", aligment: .left, color: .lightGray)
        
        registrationPasswordCheckTextField.layer.masksToBounds = true
        registrationPasswordCheckTextField.layer.cornerRadius = CornerRadius.myValue
        registrationPasswordCheckTextField.attributedPlaceholder = NSAttributedString(text: "비밀번호 확인", aligment: .left, color: .lightGray)
    }
    
    //MARK: - Transition Button
    
    private func updateTransitionUI(){
        signUpButton.backgroundColor = #colorLiteral(red: 0.8779806495, green: 0.9357933402, blue: 1, alpha: 1)
        signUpButton.cornerRadius = CornerRadius.myValue
        signUpButton.spinnerColor = .white
        signUpButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
    }

    @objc func buttonAction(_ button: TransitionButton) {
        registrationPasswordCheckTextField.resignFirstResponder()
        
        guard let email = registrationEmailTextField.text, !email.isEmpty,
              let nickName = registrationNickNameTextField.text, !nickName.isEmpty else {
            
            // 이메일, 닉네임 오류시 AlertController
            let alert = UIAlertController(title: "알림", message: "빈칸을 채워주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let password = registrationPasswordTextField.text, !password.isEmpty, password.count >= 8,
              let passwordCheck = registrationPasswordCheckTextField.text, !passwordCheck.isEmpty, password == passwordCheck else {
            
            // 비밀번호 오류시 AlertController
            let alert = UIAlertController(title: "알림", message: "비밀번호는 8자리 이상입니다. 다시 확인해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        button.startAnimation()
        UserManager.shared.registrationUser(email: email, password: password, nickName: nickName) { success in
            DispatchQueue.main.async {
                if success {
                    DispatchQueue.main.async {
                        button.stopAnimation(animationStyle: .normal) {
                            // 버튼 컴플리션 핸들러
                            self.view.window?.rootViewController?.dismiss(animated: false, completion: {
                                let sb = UIStoryboard(name: "Home", bundle: nil)
                                let postVC = sb.instantiateViewController(withIdentifier: "postVC") as! PostViewController
                                let naviVC = UINavigationController(rootViewController: postVC)
                                naviVC.modalPresentationStyle = .fullScreen
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.window?.rootViewController?.present(naviVC, animated: true, completion: nil)
                            })
                        }
                    }
                } else {
                    button.stopAnimation(animationStyle: .shake, revertAfterDelay: 1.0) {
                        let alert = UIAlertController(title: "회원가입오류", message: "데이터베이스, 회원가입에 오류!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "확인", style: .cancel)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        }
    }
    
    @objc func willShow(_ notification: NSNotification) {
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardEndFrame.cgRectValue.height
        let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let margin: CGFloat = 60
        let loginComponentsHeight = view.frame.height - stackview.frame.height - stackview.frame.origin.y
        
        UIView.animate(withDuration: keyboardAnimationDuration) {
            if loginComponentsHeight - keyboardHeight >= 0 {

            } else {
                self.middleConstraint.constant = loginComponentsHeight - keyboardHeight - margin - 15
                print(self.middleConstraint.constant)
            }
            self.view.layoutIfNeeded()
        }
    }

    @objc func willHide(_ notification: Notification) {
  
        let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let margin: CGFloat = 60
        
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.middleConstraint.constant = -margin
            self.view.layoutIfNeeded()
        }
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == registrationEmailTextField {
            registrationNickNameTextField.becomeFirstResponder()
            registrationEmailTextField.resignFirstResponder()
        } else if textField == registrationNickNameTextField {
            registrationPasswordTextField.becomeFirstResponder()
            registrationNickNameTextField.resignFirstResponder()
        } else if textField == registrationPasswordTextField {
            registrationPasswordCheckTextField.becomeFirstResponder()
            registrationPasswordTextField.resignFirstResponder()
        } else if textField == registrationPasswordCheckTextField {
            registrationPasswordCheckTextField.resignFirstResponder()
        }
        return true
    }
    
}

