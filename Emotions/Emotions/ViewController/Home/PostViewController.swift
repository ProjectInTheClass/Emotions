//
//  PostViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import UIKit
import BetterSegmentedControl

class PostViewController: UIViewController {
    
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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var homeSegmenttedControl: BetterSegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationConfigureUI()
        segmentedControlConfigureUI()
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
    
    @objc func searchPostButtonTapped() {
        print("PostTableViewController - searchPostButtonTapped()")
    }
    
    @objc func addPostButtonTapped() {
        print("PostTableViewController - addPostButtonTapped()")
    }
    
    @objc func homeSegmenttedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            // 쿼리로 정렬된 데이터가 들어올 예정
            
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
        } else if sender.index == 1 {
            print("공감 글")
        } else {
            // 쿼리로 정렬된 데이터가 들어올 예정
            
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
        }
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostManager.shared.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        let post = PostManager.shared.posts[indexPath.row]
        let comments = CommentManager.shared.comments
        cell.heartButton.tag = indexPath.row
        cell.starButton.tag = indexPath.row
        cell.updateUI(post: post, comments: comments)
        cell.delegate = self
        return cell
    }
}

extension PostViewController: PostCellDelegate {
    func heartButtonTappedInCell(_ sender: UIButton, isSelected: Bool) {
        let selectedPost = PostManager.shared.posts[sender.tag]
        selectedPost.isHeart = isSelected
        print(selectedPost.isHeart)
    }
    
    func starButtonTappedInCell(_ sender: UIButton, isSelected: Bool) {
        let selectedPost = PostManager.shared.posts[sender.tag]
        if isSelected {
            selectedPost.isGood += 1
        } else {
            selectedPost.isGood -= 1
        }
        print(selectedPost.isGood)
    }
    
    func commentButtonTappedInCell(_ sender: UIButton) {
        print("commentButton Tapped")
    }
}
