//
//  SympathyTableViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/16.
//
//
//import UIKit
//import FirebaseDatabase
//import FirebaseAuth
//
//class SympathyTableViewController: UITableViewController {
//
//    var handle: AuthStateDidChangeListenerHandle?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadSympathyTableView), name: NSNotification.Name("updateTableView"), object: nil)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tableView.reloadData()
//    }
//
//    // MARK: - Table view data source
//
//    @objc func reloadSympathyTableView() {
//        self.tableView.reloadData()
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return PostManager.shared.myHeartPosts.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: postCell, for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
//        let post = PostManager.shared.myHeartPosts[indexPath.row]
//        cell.updateUI(post: post)
//        cell.heartButtonCompletion = { currentHeartState in
//            post.isHeart = !currentHeartState
//            guard let user = Auth.auth().currentUser else { return }
//            let uid = user.uid
//            let postKey = post.postID
//            postsRef.child(postKey).runTransactionBlock { currentData  in
//                if var post = currentData.value as? [String:Any] {
//                    var heart = post["heartUser"] as? [String:Bool] ?? [:]
//                    if !currentHeartState {
//                        heart[uid] = true
//                    } else {
//                        heart.removeValue(forKey: uid)
//                    }
//                    post["heartUser"] = heart
//                    currentData.value = post
//                    return TransactionResult.success(withValue: currentData)
//                }
//                return TransactionResult.success(withValue: currentData)
//            }
//        }
//
//        cell.starButtonCompletion = { currentStarState in
//            post.isStar = !currentStarState
//            guard let user = Auth.auth().currentUser else { return }
//            let uid = user.uid
//            let postKey = post.postID
//            postsRef.child(postKey).runTransactionBlock { currentData -> TransactionResult in
//                if var post = currentData.value as? [String:Any] {
//                    var star = post["starUser"] as? [String:Bool] ?? [:]
//                    var starPoint = post["starPoint"] as? Int ?? 0
//                    if !currentStarState {
//                        star[uid] = true
//                        starPoint += 1
//                    } else {
//                        star[uid] = false
//                        star.removeValue(forKey: uid)
//                        starPoint -= 1
//                    }
//                    post["starUser"] = star
//                    post["starPoint"] = starPoint
//                    currentData.value = post
//                    return TransactionResult.success(withValue: currentData)
//                }
//                return TransactionResult.success(withValue: currentData)
//            }
//        }
//
//        cell.commentButtonCompletion = {
////            guard let self = self else { return }
////            let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
////            guard let postDetailViewController = homeStoryboard.instantiateViewController(withIdentifier: "postDetailVC") as? PostDetailViewController else { return }
////            postDetailViewController.post = post
////            self.navigationController?.pushViewController(postDetailViewController, animated: true)
//        }
//        return cell
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "sympathyDetailSegue" {
//            guard let indexPath = tableView.indexPathForSelectedRow else {
//                print("indexPathForSelectedRow")
//                return }
//            let post = PostManager.shared.myHeartPosts[indexPath.row] // myHeartsPosts = PostManager 참고
//            guard let postDetailViewController = segue.destination as? PostDetailViewController else { return }
//            postDetailViewController.post = post
//        }
//    }
//
//
//}
