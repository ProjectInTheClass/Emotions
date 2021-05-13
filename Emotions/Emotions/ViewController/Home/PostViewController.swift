//
//  PostViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

// 4월 21일 리팩토링 체크

import UIKit
import BetterSegmentedControl
import TransitionButton
import FirebaseDatabase
import FirebaseAuth
import Kingfisher

class PostViewController: CustomTransitionViewController {
    
    let emotionsTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainLogo")
        imageView.alpha = 0.8
        return imageView
    }()
    
    lazy var addPostButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addPost"), for: .normal)
        button.addTarget(self, action: #selector(addPostButtonTapped), for: .touchUpInside)
     
        return button
    }()
    
    var handle: AuthStateDidChangeListenerHandle?
    var user: User?
    
    @IBOutlet weak var homeSegmenttedControl: BetterSegmentedControl!
    @IBOutlet weak var latestContainerView: UIView!
    @IBOutlet weak var starContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfigureUI()
        segmentedControlConfigureUI()
        initialSegmentControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if auth.currentUser == nil {
                self.user = nil
            } else {
                self.user = auth.currentUser
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: - UI Functions
    
    func segmentedControlConfigureUI() {
        homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: sadnessBGColor)
        homeSegmenttedControl.cornerRadius = 17
        homeSegmenttedControl.backgroundColor = .white
        homeSegmenttedControl.alwaysAnnouncesValue = true
        homeSegmenttedControl.segments = LabelSegment.segments(withTitles: ["최신 글", "추천 글"],
                                                               normalTextColor: UIColor(red: 0.48, green: 0.48, blue: 0.51, alpha: 1.00))
        homeSegmenttedControl.addTarget(self, action: #selector(homeSegmenttedControlValueChanged(_:)), for: .valueChanged)
    }
    
    func navigationConfigureUI() {
        navigationItem.title = ""
        let addButton = UIBarButtonItem(customView: addPostButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: emotionsTitle)
        navigationItem.rightBarButtonItems = [addButton]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func initialSegmentControl(){
        latestContainerView.isHidden = false
        starContainerView.isHidden = true
    }
    
    //MARK: - OBJC Functions
    
    @objc func addPostButtonTapped() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let addPostViewController = storyboard.instantiateViewController(withIdentifier: "addPostVC") as? AddPostViewController else { return }
        self.navigationController?.pushViewController(addPostViewController, animated: true)
    }
    
    @objc func homeSegmenttedControlValueChanged(_ sender: BetterSegmentedControl) {
        
        if sender.index == 0 {
            homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: sadnessBGColor)
            latestContainerView.isHidden = false
            starContainerView.isHidden = true
        } else {
            homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: joyBGColor)
            latestContainerView.isHidden = true
            starContainerView.isHidden = false
        }
    }
}
