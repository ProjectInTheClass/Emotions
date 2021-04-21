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
import BLTNBoard

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
    
    lazy var bulletinManager: BLTNItemManager = {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.lightGray
        shadow.shadowBlurRadius = 2
        let attribute : [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 14, weight: .light),
            .foregroundColor : UIColor.black,
            .shadow : shadow,
        ]
        let attributeString = NSAttributedString(string: "'감정들'과 함께 숨은 감정을 발견하고 이웃들과 공유하세요!\n 감정을 건강하게 관리할 수 있습니다:)", attributes: attribute)
        let page = BLTNPageItem(title: "감정들 함께하기")
        page.appearance.titleTextColor = .black
        page.appearance.titleFontSize = 22.0
        page.appearance.titleFontDescriptor = UIFontDescriptor(name: "ridibatang", size: 24.0)
        page.attributedDescriptionText = attributeString
        page.actionButtonTitle = "감정들 로그인 & 회원가입"
        page.alternativeButtonTitle = "조금 더 둘러볼래요"
        page.appearance.alternativeButtonTitleColor = UIColor(named: emotionDeepGreen)!
        page.image = UIImage(named: "invitation")
        page.requiresCloseButton = false
        page.appearance.actionButtonColor = UIColor(named: emotionDeepGreen)!
        page.appearance.actionButtonTitleColor = .white
        page.actionHandler = { (item: BLTNActionItem) in
            
            self.dismiss(animated: true) {
                let sb = UIStoryboard(name: "Home", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
        page.alternativeHandler = { (item: BLTNActionItem) in
            self.dismiss(animated: true, completion: nil)
        }
        return BLTNItemManager(rootItem: page)
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
        AuthManager.shared.checkLogin { success in
            if success {
                DispatchQueue.main.async {
                    self.bulletinManager.showBulletin(above: self)
                }
            } else {
                print("유저 자동 로그인")
            }
        }
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
        AuthManager.shared.checkLogin { success in
            if success {
                DispatchQueue.main.async {
                    self.bulletinManager.showBulletin(above: self)
                }
            } else {
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                guard let addPostViewController = storyboard.instantiateViewController(withIdentifier: "addPostVC") as? AddPostViewController else { return }
                self.navigationController?.pushViewController(addPostViewController, animated: true)
            }
        }
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
