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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateTransitionUI()
        
    }
    
    //MARK: - UI Update
    
    private func updateUI() {
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
}

