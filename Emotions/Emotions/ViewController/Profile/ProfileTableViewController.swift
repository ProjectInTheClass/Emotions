//
//  ProfileTableViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/23.
//

import UIKit
import FirebaseAuth

class ProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let logoutIndexPath = IndexPath(row: 3, section: 1)
    let profileImage = IndexPath(row: 0, section: 1)
    
    var profileImageSelectCompletionhandler: ((UIImage)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == logoutIndexPath {
            let alert = UIAlertController(title: "로그아웃", message: "로그아웃하시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .destructive) { (alert) in
                AuthManager.shared.logoutUser { (success) in
                    if success {
                        
                    } else {
                        print("로그아웃 실패")
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        } else if indexPath == profileImage {
            
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
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("imagePickerController")
        guard let selectedImage = info[.originalImage] as? UIImage else { print("사진 없어")
            return }
        if let currentUser = Auth.auth().currentUser {
            UserManager.shared.uploadUserImage(userImage: selectedImage, email: currentUser.email!) {  [weak self] success in
                guard let self = self else { return }
                if success {
                    UserManager.shared.downloadUserImage(email: currentUser.email!) { [weak self] (url) in
                        guard let self = self else { return }
                        if let data = try? Data(contentsOf: url!) {
                            guard let image = UIImage(data: data) else { return }
                            if let profileImageSelectCompletionhandler = self.profileImageSelectCompletionhandler {
                                profileImageSelectCompletionhandler(image)
                            }
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
