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
    
    @IBOutlet weak var loadingLabel: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var homeSegmenttedControl: BetterSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: Notification.Name("postsValueChanged"), object: nil)
        navigationConfigureUI()
        segmentedControlConfigureUI()
        initRefresh()
        
        DataManager.shared.loadPosts { success in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
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
    
    // MARK: - Functions
    
    func initRefresh() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        DataManager.shared.loadFreshPosts { success in
            if success {
                self.tableView.reloadData()
            }
        }
        tableView.refreshControl?.endRefreshing()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height + self.loadingLabel.frame.height - contentYoffset
        if distanceFromBottom < height {
            print(" you reached end of the table")
            DataManager.shared.loadPastPosts { success in
                if success {
                    self.tableView.reloadData()
                }
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
            print("최신 글")
            homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: "emotionLightGreen")
        } else if sender.index == 1 {
            print("공감 글")
            homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: "emotionLightPink")
        } else {
            print("좋은 글")
            homeSegmenttedControl.indicatorViewBackgroundColor = UIColor(named: "joyBG")
        }
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.latestposts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        let post = DataManager.shared.latestposts[indexPath.row]
        let comments = CommentManager.shared.comments
        cell.updateUI(post: post, comments: comments)
        
        // 네트워크 호출시에 이곳에서 데이터 변경하도록 호출 그게 완료되면 보여지는게 바뀌도록 
        cell.heartButtonCompletion = { currentHeartState in
            post.isHeart = !currentHeartState
            let postKey = post.postID
            database.child("posts").child(postKey).runTransactionBlock { currentData  in
                if var post = currentData.value as? [String:Any],
                   let uid = AuthManager.shared.currentUser?.uid {
                    var heart = post["heartUser"] as? [String:Bool] ?? [:]
                    if !currentHeartState {
                        heart[uid] = true
                    } else {
                        heart.removeValue(forKey: uid)
                    }
                    post["heartUser"] = heart
                    currentData.value = post
                    return TransactionResult.success(withValue: currentData)
                }
                return TransactionResult.success(withValue: currentData)
            }
        }
    
        cell.starButtonCompletion = { currentStarState in
            post.isStar = !currentStarState
            let postKey = post.postID
            database.child("posts").child(postKey).runTransactionBlock { currentData -> TransactionResult in
                if var post = currentData.value as? [String:Any],
                   let uid = AuthManager.shared.currentUser?.uid {
                    var star = post["starUser"] as? [String:Bool] ?? [:]
                    var starPoint = post["starPoint"] as? Int ?? 0
                    if !currentStarState {
                        star[uid] = true
                        starPoint += 1
                    } else {
                        star[uid] = false
                        star.removeValue(forKey: uid)
                        starPoint -= 1
                    }
                    post["starUser"] = star
                    post["starPoint"] = starPoint
                    currentData.value = post
                    return TransactionResult.success(withValue: currentData)
                }
                return TransactionResult.success(withValue: currentData)
            }
        }
        
        cell.commentButtonCompletion = { [weak self] in
//            guard let self = self else { return }
//            let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
//            guard let postDetailViewController = homeStoryboard.instantiateViewController(withIdentifier: "postDetailVC") as? PostDetailViewController else { return }
//            postDetailViewController.post = post
//            self.navigationController?.pushViewController(postDetailViewController, animated: true)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetailSegue" {
//            guard let indexPath = tableView.indexPathForSelectedRow else {
//                print("indexPathForSelectedRow")
//                return }
//            let post = DataManager.shared.latestposts[indexPath.row]
//            guard let postDetailViewController = segue.destination as? PostDetailViewController else { return }
//            postDetailViewController.post = post
        }
    }
}
