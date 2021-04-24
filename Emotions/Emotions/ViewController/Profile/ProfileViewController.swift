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
    
    // 포토갤러리에서 선택한 이미지가 들어있음.
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = auth.currentUser {
                DispatchQueue.main.async {
                    self.logoutview.isHidden = true
                    self.profileContainerView.isHidden = false
                    self.userEmailLabel.text = user.email
                    self.userNickNameLabel.text = user.displayName
                    if let photoURL = user.photoURL,
                       let data = try? Data(contentsOf: photoURL) {
                        guard let image = UIImage(data: data) else { return }
                        self.userImageView.image = image
                    } else {
                        print("Error convert URL to Data")
                    }
                }
            } else {
                self.logoutview.isHidden = false
                self.userEmailLabel.text = "user@email.com"
                self.userNickNameLabel.text = "user nickname"
                self.userImageView.image = UIImage(systemName: "person.circle")!
                self.profileContainerView.isHidden = true
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func profileUpdateButton(_ sender: UIBarButtonItem) {
       
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
            print("imagePickerController - currentUserEmail")
            UserManager.shared.uploadUserImage(userImage: selectedImage, email: currentUser.email!) { success in
                if success {
                    UserManager.shared.downloadUserImage(email: currentUser.email!) { (url) in
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
