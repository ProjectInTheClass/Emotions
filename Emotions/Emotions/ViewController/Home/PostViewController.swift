//
//  PostViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import UIKit
import BetterSegmentedControl
import TransitionButton
import FirebaseDatabase

class PostViewController: CustomTransitionViewController {
    
    let emotionsTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "homeNaviTitle")
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
        button.setImage(UIImage(named: "searchPost"), for: .normal)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AuthManager.shared.checkLogin { success in
            if success {
                DispatchQueue.main.async {
                    let sb = UIStoryboard(name: "Home", bundle: nil)
                    guard let vc = sb.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController else { return }
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: false)
                }
            } else {
                print("유저 자동 로그인")
            }
        }
    }
    
    // MARK: - UI Functions
    
    func segmentedControlConfigureUI() {
        homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: "emotionLightGreen")
        homeSegmenttedControl.cornerRadius = 8
        homeSegmenttedControl.backgroundColor = .white
        homeSegmenttedControl.alwaysAnnouncesValue = true
        homeSegmenttedControl.segments = LabelSegment.segments(withTitles: ["최신 글", "공감 글", "좋은 글"],
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
        print("PostTableViewController - searchPostButtonTapped()")
    }
    
    @objc func addPostButtonTapped() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let addPostViewController = storyboard.instantiateViewController(withIdentifier: "addPostVC") as? AddPostViewController else { return }
        navigationController?.pushViewController(addPostViewController, animated: true)
    }
    
    @objc func homeSegmenttedControlValueChanged(_ sender: BetterSegmentedControl) {
        // 다양한 레포에 따른 반응을 구현하도록 임시저장소를 만들어야 한다. 단순히 array를 바꿔가며 사용하는게 좋은가? 아니면 다른 방법이 있을가 고민해봐야 한다.
        if sender.index == 0 {
            print("최신 글")
            homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: "emotionLightGreen")
            latestContainerView.isHidden = false
            sympathyContainerView.isHidden = true
            starContainerView.isHidden = true
        } else if sender.index == 1{
            print("공감 글")
            homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: "emotionLightPink")
            latestContainerView.isHidden = true
            sympathyContainerView.isHidden = false
            starContainerView.isHidden = true
        } else {
            print("좋은 글")
            homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: "joyBG")
            latestContainerView.isHidden = true
            sympathyContainerView.isHidden = true
            starContainerView.isHidden = false
        }
    }
}
