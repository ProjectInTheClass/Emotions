//
//  StarTableViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/16.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class StarTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStarTableView), name: NSNotification.Name("updateTableView"), object: nil)
    }

    // MARK: - Table view data source
    
    @objc func reloadStarTableView() {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostManager.shared.starPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: postCell, for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        let realPost = PostManager.shared.starPosts[indexPath.row]
        cell.updateUI(post: realPost)
        cell.heartButtonCompletion = { currentHeartState in
            realPost.isHeart = !currentHeartState
            let postKey = realPost.postID
            database.child("posts").child(postKey).runTransactionBlock { currentData  in
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
            database.child("posts").child(postKey).runTransactionBlock { currentData -> TransactionResult in
                if var post = currentData.value as? [String:Any],
                   let uid = Auth.auth().currentUser?.uid {
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
        if segue.identifier == "starDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                print("indexPathForSelectedRow")
                return }
            let post = PostManager.shared.starPosts[indexPath.row] //starPosts = PostManager 참고
            guard let postDetailViewController = segue.destination as? PostDetailViewController else { return }
            postDetailViewController.post = post
        }
    }


}
