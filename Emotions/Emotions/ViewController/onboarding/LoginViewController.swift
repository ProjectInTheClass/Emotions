//
//  LoginViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/14.
//

import UIKit
import TransitionButton

class LoginViewController: UIViewController {
    
    
    //MARK: -Property
    
   
    //MARK: - Outlet
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: TransitionButton!
    
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var passwordFindingButton: UIButton!
    @IBOutlet weak var browseButton: UIButton!
    
    var afterLoginCompletion: (()->Void)?
    
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var middleConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    
    
    //MARK: - ViewLife Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        ButtonAddTarget()
        errorMessageLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(willShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - UI Function
    
    private func updateUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.cornerRadius = CornerRadius.myValue
        emailTextField.attributedPlaceholder = NSAttributedString(text: "이메일", aligment: .left, color: .lightGray)
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.cornerRadius = CornerRadius.myValue
        passwordTextField.attributedPlaceholder = NSAttributedString(text: "비밀번호", aligment: .left, color: .lightGray)
        loginButton.spinnerColor = .white
        loginButton.cornerRadius = CornerRadius.myValue
    }
    //MARK: - IBAction
    
    private func ButtonAddTarget() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registrationButton.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        browseButton.addTarget(self, action: #selector(browseButtonTapped), for: .touchUpInside)
    }
  
    @objc func loginButtonTapped() {
        // 로그인버튼 누르면 키보드 내려가도록
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        
        guard let email = emailTextField.text,
              !email.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty else {
            
            // 오류시 AlertController
            let alert = UIAlertController(title: "알림", message: "빈칸을 채워주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        loginButton.startAnimation()
        UserManager.shared.loginUser(email: email, password: password) { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    self.errorMessageLabel.isHidden = true
                    self.loginButton.stopAnimation()
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.errorMessageLabel.isHidden = false
                self.errorMessageLabel.text = "이메일과 패스워드를 확인해주세요."
                self.loginButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.2)
                
            }
            
        }
    }
    
    @objc func registrationButtonTapped() {
        self.errorMessageLabel.isHidden = true
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "registrationVC") as! RegistrationViewController
        present(vc, animated: true, completion: nil)
    }
    
    @objc func browseButtonTapped() {
        self.dismiss(animated: true, completion: nil)
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

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            loginButtonTapped()
        }
        return true
    }
    
}
