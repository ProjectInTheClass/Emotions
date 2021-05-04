//
//  ProfileViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/08.
//

import UIKit
import FirebaseAuth
import Kingfisher

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
    
    var pickerImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        navigationConfigureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("viewwilllayoutsubview")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            if let user = auth.currentUser {
                self.profileContainerView.isHidden = true
                self.profileContainerView.isHidden = false
                DispatchQueue.main.async {
                    self.updateUI(user: user)
                }
            } else {
                self.profileContainerView.isHidden = false
                self.profileContainerView.isHidden = true
                DispatchQueue.main.async {
                    self.updateUI(user: user)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: - update UI
    
    func updateUI(user: User?) {
        userEmailLabel.text = user?.email ?? nil
        userNickNameLabel.text = user?.displayName ?? nil
        if let photoURL = user?.photoURL {
            self.userImageView.kf.setImage(with: photoURL, options: [.forceRefresh])
        } else {
            print("Error convert URL to Data")
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
}
