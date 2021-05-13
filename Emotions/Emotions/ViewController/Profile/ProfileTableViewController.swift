//
//  ProfileTableViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/23.
//

import UIKit
import FirebaseAuth
import Kingfisher
import SafariServices
import MessageUI

class ProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNickNameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var loginbutton: UIView!
    
    
    let emotionsTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainLogo")
        imageView.alpha = 0.8
        return imageView
    }()
    
    let logoutIndexPath = IndexPath(row: 2, section: 1)
    let loginIndexPath = IndexPath(row: 1, section: 1)
    let profileImageIndexPath = IndexPath(row: 0, section: 1)
    let appIntroduceIndexPath = IndexPath(row: 2, section: 0)
    let askForInformation = IndexPath(row: 3, section: 0)
    
    //MARK: - View Life Cyle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureUI()
        navigationConfigureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("updateTableView"), object: nil)
    }
    
    //MARK: - Function UI
    
    @objc func updateUI() {
        if let user = Auth.auth().currentUser {
            userEmailLabel.text = user.email
            userNickNameLabel.text = user.displayName
            userImageView.kf.setImage(with: user.photoURL, placeholder: UIImage(systemName: "person.circle"), options: [.forceRefresh])
            tableView.reloadData()
        } else {
            userEmailLabel.text = "email"
            userNickNameLabel.text = "username"
            userImageView.image = UIImage(systemName: "person.circle")
            tableView.reloadData()
        }
    }
    
    func configureUI(){
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView!.bounds.height / 2
    }
    
    func navigationConfigureUI() {
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: emotionsTitle)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    //MARK: - tableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == loginIndexPath {
            return Auth.auth().currentUser == nil ? 44 : 0
        } else if indexPath == logoutIndexPath {
            return Auth.auth().currentUser == nil ? 0 : 44
        } else if indexPath == profileImageIndexPath {
            return Auth.auth().currentUser == nil ? 0 : 44
        } else {
            return 44
        }
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
            
        } else if indexPath == profileImageIndexPath {
//            guard let currenUser = Auth.auth().currentUser else { return }
             let imagePickerViewController = UIImagePickerController()
             imagePickerViewController.delegate = self
             let actionSheet = UIAlertController(title: "사진 추가하기", message: nil, preferredStyle: .actionSheet)
        
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
        } else if indexPath == appIntroduceIndexPath {
            if let url = URL(string: "https://projectintheclass.github.io/Emotions/") {
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true, completion: nil)
            }
        } else if indexPath == askForInformation {
            if !MFMailComposeViewController.canSendMail() {
                print("Cannot send Email")
                return
            }
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.delegate = self
            mailComposeViewController.setToRecipients(["phs880623@gmail.com"])
            mailComposeViewController.setSubject("문의할게 있습니다!")
            mailComposeViewController.setMessageBody("문의사항을 기록해 주세요.", isHTML: false)
            present(mailComposeViewController, animated: true, completion: nil)
        } else if indexPath == loginIndexPath {
            let sb = UIStoryboard(name: "Home", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        UserManager.shared.uploadUserImage(userImage: selectedImage, email: currentUserEmail) { success in }
        userImageView.image = selectedImage
        self.dismiss(animated: true)
    }
}
