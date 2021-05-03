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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        navigationConfigureUI()
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "profileTableVC") as? ProfileTableViewController else { return }
        vc.profileImageSelectCompletionhandler = { [weak self] image in
            guard let self = self else { return }
            self.userImageView.image = image
        }
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
        self.userEmailLabel.text = user?.email ?? nil
        self.userNickNameLabel.text = user?.displayName ?? nil
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: emotionsTitle)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
