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

class PostViewController: CustomTransitionViewController {
    
    let emotionsTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainLogo")
        return imageView
    }()
    
    lazy var addPostButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addPost"), for: .normal)
        button.addTarget(self, action: #selector(addPostButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var searchPostButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "user"), for: .normal)
        button.addTarget(self, action: #selector(searchPostButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @IBOutlet weak var homeSegmenttedControl: BetterSegmentedControl!
    @IBOutlet weak var latestContainerView: UIView!
    @IBOutlet weak var sympathyContainerView: UIView!
    @IBOutlet weak var starContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfigureUI()
        segmentedControlConfigureUI()
        latestContainerView.isHidden = false
        sympathyContainerView.isHidden = true
        starContainerView.isHidden = true
    }
    
    // MARK: - UI Functions
    
    func segmentedControlConfigureUI() {
        homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: emotionLightGreen)
        homeSegmenttedControl.cornerRadius = 20
        homeSegmenttedControl.backgroundColor = .white
        homeSegmenttedControl.alwaysAnnouncesValue = true
        homeSegmenttedControl.segments = LabelSegment.segments(withTitles: ["최신 글", "공감 글", "별점 글"],
                                                               normalTextColor: UIColor(red: 0.48, green: 0.48, blue: 0.51, alpha: 1.00))
        homeSegmenttedControl.addTarget(self, action: #selector(homeSegmenttedControlValueChanged(_:)), for: .valueChanged)
    }
    
    func navigationConfigureUI() {
        navigationItem.title = ""
        let addButton = UIBarButtonItem(customView: addPostButton)
        let searchButton = UIBarButtonItem(customView: searchPostButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: emotionsTitle)
        navigationItem.rightBarButtonItems = [addButton, searchButton]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK: - OBJC Functions
    
    // 아직 구현안함 + 나중에 추가하거나 제거
    @objc func searchPostButtonTapped() {
        AuthManager.shared.logoutUser { success in
            if success {
                print("성공")
            } else {
                print("실패")
            }
        }
    }
    
    @objc func addPostButtonTapped() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let addPostViewController = storyboard.instantiateViewController(withIdentifier: "addPostVC") as? AddPostViewController else { return }
        self.navigationController?.pushViewController(addPostViewController, animated: true)
    }
    
    @objc func homeSegmenttedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: emotionLightGreen)
            latestContainerView.isHidden = false
            sympathyContainerView.isHidden = true
            starContainerView.isHidden = true
        } else if sender.index == 1 {
            homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: emotionLightPink)
            AuthManager.shared.checkLogin { success in
                if success {
                    DispatchQueue.main.async {
                        self.latestContainerView.isHidden = true
                        self.sympathyContainerView.isHidden = true
                        self.starContainerView.isHidden = true
                    }
                } else {
                    self.latestContainerView.isHidden = true
                    self.sympathyContainerView.isHidden = false
                    self.starContainerView.isHidden = true
                }
            }
        } else {
            homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: "joyBG")
            latestContainerView.isHidden = true
            sympathyContainerView.isHidden = true
            starContainerView.isHidden = false
        }
    }
}
