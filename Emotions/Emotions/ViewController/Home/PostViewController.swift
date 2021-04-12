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
        NotificationCenter.default.addObserver(tableView, selector: #selector(UITableView.reloadData), name: Notification.Name("postsValueChanged"), object: nil)
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
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let addPostViewController = storyboard.instantiateViewController(withIdentifier: "addPostVC") as? AddPostViewController else { return }
        navigationController?.pushViewController(addPostViewController, animated: true)
    }
    
    @objc func homeSegmenttedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: "emotionLightGreen")
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            print("최신 글")
        } else if sender.index == 1 {
            homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: "emotionDeepPink")
            print("공감 글")
        } else {
            homeSegmenttedControl.indicatorViewBackgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            print("좋은 글")
            
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
        cell.updateUI(post: post, comments: comments)
        
        // 네트워크 호출시에 이곳에서 데이터 변경하도록 호출 그게 완료되면 보여지는게 바뀌도록 
        cell.heartButtonCompletion = { currentHearState in
            post.isHeart = !currentHearState
//            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        cell.starButtonCompletion = { currentStarState in
            post.isGood = !currentStarState
//            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        cell.commentButtonCompletion = {
            print("실행!")
        }
        
        return cell
    }
}
