//
//  SympathyTableViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/16.
//

import UIKit
import FirebaseDatabase

class SympathyTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        PostManager.shared.loadPostsByHeart { success in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("failure")
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
        PostManager.shared.myHeartPosts = []
        PostManager.shared.loadPostsByHeart { success in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("failure")
            }
        }
        tableView.refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostManager.shared.myHeartPosts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: postCell, for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        let post = PostManager.shared.myHeartPosts[indexPath.row]
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
