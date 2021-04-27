//
//  ProfileViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/08.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNickNameLabel: UILabel!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var logoutview: UIStackView!
    
    let emotionsTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainLogo")
        return imageView
    }()
    
    lazy var updateProfileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.circle"), for: .normal)
        button.addTarget(self, action: #selector(updateProfileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        navigationConfigureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = auth.currentUser {
                self.profileContainerView.isHidden = true
                self.profileContainerView.isHidden = false
                self.updateUI(user: user)
            } else {
                self.profileContainerView.isHidden = false
                self.profileContainerView.isHidden = true
                self.updateUI(user: user)
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: - update UI
    
    func updateUI(user: User?) {
        self.userImageView.image = nil
        self.userEmailLabel.text = user?.email ?? "Email"
        self.userNickNameLabel.text = user?.displayName ?? "Nickname"
        if let photoURL = user?.photoURL,
           let data = try? Data(contentsOf: photoURL) {
            let image = UIImage(data: data)!
            self.userImageView.image = image
        } else {
            print("Error convert URL to Data")
        }
    }
    
    func configureUI(){
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
    }
    
    func navigationConfigureUI() {
        navigationItem.title = ""
        let addButton = UIBarButtonItem(customView: updateProfileButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: emotionsTitle)
        navigationItem.rightBarButtonItems = [addButton]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - Functions
    
    @objc func updateProfileButtonTapped() {
        
         let imagePickerViewController = UIImagePickerController()
         imagePickerViewController.delegate = self
         let actionSheet = UIAlertController(title: "사진 추가하기", message: nil, preferredStyle: .actionSheet)
         if UIImagePickerController.isSourceTypeAvailable(.camera) {
             let cameraAction = UIAlertAction(title: "카메라", style: .default) { action in
                 imagePickerViewController.sourceType = .camera
                 self.present(imagePickerViewController, animated: true, completion: nil)
             }
             actionSheet.addAction(cameraAction)
         }
         if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
             let photoAction = UIAlertAction(title: "사진첩", style: .default) { action in
                 imagePickerViewController.sourceType = .photoLibrary
                 self.present(imagePickerViewController, animated: true, completion: nil)
             }
             actionSheet.addAction(photoAction)
         }
         let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
             self.dismiss(animated: true, completion: nil)
         }
         actionSheet.addAction(cancelAction)
         present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("imagePickerController")
        guard let selectedImage = info[.originalImage] as? UIImage else { print("사진 없어")
            return }
        if let currentUser = Auth.auth().currentUser {
            UserManager.shared.uploadUserImage(userImage: selectedImage, email: currentUser.email!) {  [weak self] success in
                guard let self = self else { return }
                self.userImageView.image = nil
                if success {
                    UserManager.shared.downloadUserImage(email: currentUser.email!) { [weak self] (url) in
                        guard let self = self else { return }
                        if let data = try? Data(contentsOf: url!) {
                            guard let image = UIImage(data: data) else { return }
                            self.userImageView.image = image
                        } else {
                            print("Error convert URL to Data")
                        }
                    }
                } else {
                    print("실파이")
                }
            }
        } else {
            print("유저 없음")
        }
        dismiss(animated: true, completion: nil)
    }
    
}
