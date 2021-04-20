//
//  LatestPostsTableViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/16.
//

import UIKit
import FirebaseDatabase

class LatestPostsTableViewController: UITableViewController {
   
    @IBOutlet weak var loadingLabel: UIActivityIndicatorView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRefresh()
        DataManager.shared.loadPosts { success in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    // MARK: - Functions
    
    private func initRefresh() {
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
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
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.latestposts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: postCell, for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
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
        
        cell.commentButtonCompletion = {
//            guard let self = self else { return }
//            let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
//            guard let postDetailViewController = homeStoryboard.instantiateViewController(withIdentifier: "postDetailVC") as? PostDetailViewController else { return }
//            postDetailViewController.post = post
//            self.navigationController?.pushViewController(postDetailViewController, animated: true)
        }
        
        cell.reportButtonCompletion = { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: "신고하기", message: "\n이 게시물을 신고하고 삭제합니다.\n 신고가 누적된 사용자는 사용이 제한됩니다. 좋은 커뮤니티 문화를 함께 만들어 주세요.", preferredStyle: .alert)
            let okAciton = UIAlertAction(title: "신고하기", style: .destructive) { (alert) in
                DataManager.shared.latestposts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()
                database.child("posts").child(post.postID).runTransactionBlock { currentData -> TransactionResult in
                    if var currentPost = currentData.value as? [String:Any],
                       let uid = AuthManager.shared.currentUser?.uid {
                        var report = currentPost["reportedUser"] as? [String:Bool] ?? [:]
                        report[uid] = true
                        currentPost["reportedUser"] = report
                        if report.count >= 5 {
                            blackList.child(post.userID).setValue(post.postID)
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
//            guard let indexPath = tableView.indexPathForSelectedRow else {
//                print("indexPathForSelectedRow")
//                return }
//            let post = DataManager.shared.latestposts[indexPath.row]
//            guard let postDetailViewController = segue.destination as? PostDetailViewController else { return }
//            postDetailViewController.post = post
        }
    }
   

}
