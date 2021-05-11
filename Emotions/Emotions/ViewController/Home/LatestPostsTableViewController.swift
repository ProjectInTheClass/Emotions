//
//  LatestPostsTableViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/16.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import BLTNBoard

class LatestPostsTableViewController: UITableViewController {
    
    @IBOutlet weak var loadingLabel: UIActivityIndicatorView!
    
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
        page.appearance.titleFontDescriptor = UIFontDescriptor(name: "NanumSquareR", size: 24.0)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadLatestTableView), name: NSNotification.Name("updateTableView"), object: nil)
    }
    
    // MARK: - Functions
    
    @IBAction func commentDetailButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview?.superview as? PostTableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post = PostManager.shared.latestposts[indexPath.row]
        let sb = UIStoryboard(name: "Detail", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "detailVC") as? PostDetailViewController else { return }
        vc.post = post
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func reloadLatestTableView() {
        if Auth.auth().currentUser == nil {
            bulletinManager.showBulletin(above: self)
        }
        self.tableView.reloadData()
    }
    
    private func initRefresh() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "최신 글 가져오기")
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            self.tableView.refreshControl?.endRefreshing()
            return }
        PostManager.shared.loadFreshPosts(currentUserUID: currentUserUID) { success in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height + self.loadingLabel.frame.height - contentYoffset
        if distanceFromBottom < height {
            print("you reached end of the table")
            PostManager.shared.loadPastPosts { success in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostManager.shared.latestposts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: postCell, for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        let realPost = PostManager.shared.latestposts[indexPath.row]
        cell.updateUI(post: realPost)
        cell.heartButtonCompletion = { currentHeartState in
            realPost.isHeart = !currentHeartState
            let postKey = realPost.postID
            postsRef.child(postKey).runTransactionBlock { currentData  in
                if var post = currentData.value as? [String:Any],
                   let uid = Auth.auth().currentUser?.uid {
                    var heart = post["heartUser"] as? [String:Bool] ?? [:]
                    if !currentHeartState {
                        DispatchQueue.main.async {
                            PostManager.shared.myHeartPosts.insert(realPost, at: 0)
                        }
                        heart[uid] = true
                    } else {
                        DispatchQueue.main.async {
                            let index = PostManager.shared.myHeartPosts.firstIndex { $0.postID == realPost.postID }
                            PostManager.shared.myHeartPosts.remove(at: index!)
                        }
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
            realPost.isStar = !currentStarState
            let postKey = realPost.postID
            postsRef.child(postKey).runTransactionBlock { currentData -> TransactionResult in
                if var post = currentData.value as? [String:Any],
                   let uid = Auth.auth().currentUser?.uid {
                    var star = post["starUser"] as? [String:Bool] ?? [:]
                    var starPoint = post["starPoint"] as? Int ?? 0
                    if !currentStarState {
                        star[uid] = true
                        starPoint += 1
                        realPost.starPoint += 1
                    } else {
                        star[uid] = false
                        star.removeValue(forKey: uid)
                        starPoint -= 1
                        realPost.starPoint -= 1
                    }
                    post["starUser"] = star
                    post["starPoint"] = starPoint
                    currentData.value = post
                    return TransactionResult.success(withValue: currentData)
                }
                return TransactionResult.success(withValue: currentData)
            }
        }
        
        cell.reportButtonCompletion = { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: "신고하기", message: "\n이 게시물을 신고하고 삭제합니다.\n 신고가 누적된 사용자는 사용이 제한됩니다. 좋은 커뮤니티 문화를 함께 만들어 주세요.", preferredStyle: .alert)
            let okAciton = UIAlertAction(title: "신고하기", style: .destructive) { (alert) in
                PostManager.shared.latestposts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()
                postsRef.child(realPost.postID).runTransactionBlock { currentData -> TransactionResult in
                    if var currentPost = currentData.value as? [String:Any],
                       let uid = Auth.auth().currentUser?.uid {
                        var report = currentPost["reportedUser"] as? [String:Bool] ?? [:]
                        report[uid] = true
                        currentPost["reportedUser"] = report
                        if report.count >= 5 {
                            blackList.child(realPost.userID).setValue(realPost.postID)
                        }
                        currentData.value = currentPost
                        return TransactionResult.success(withValue: currentData)
                    }
                    return TransactionResult.success(withValue: currentData)
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(okAciton)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return }
            let post = PostManager.shared.latestposts[indexPath.row] // DataManager 참고
            guard let postDetailViewController = segue.destination as? PostDetailViewController else { return }
            postDetailViewController.post = post
        }
    }
}
