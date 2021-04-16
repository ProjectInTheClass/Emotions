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
    
    //MARK: - ViewLife Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        ButtonAddTarget()
    }
    
    // MARK: - UI Function
    
    private func updateUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.cornerRadius = CornerRadius.myValue
        emailTextField.attributedPlaceholder = NSAttributedString(text: "이메일", aligment: .left, color: .white)
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.cornerRadius = CornerRadius.myValue
        passwordTextField.attributedPlaceholder = NSAttributedString(text: "비밀번호", aligment: .left, color: .white)
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
        AuthManager.shared.loginUser(email: email, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    self.loginButton.stopAnimation()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.loginButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.2)
                }
            }
        }
    }
    
    @objc func registrationButtonTapped() {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "registrationVC") as! RegistrationViewController
        present(vc, animated: true, completion: nil)
    }
    
    @objc func browseButtonTapped() {
        
        // 일단은 디스미스
        self.dismiss(animated: true, completion: nil)
        
        // 바로 로그인뷰가 다시 올라온다. 둘러보기를 어떻게 할건지 고민 추가
        
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