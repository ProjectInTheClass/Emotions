//
//  MyPostTableViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/16.
//

import UIKit
import FirebaseAuth

class MyPostTableViewController: UITableViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    let emotionsTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainLogo")
        return imageView
    }()
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var userPostCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfigureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if auth.currentUser == nil {
                DispatchQueue.main.async {
                    PostManager.shared.userPosts = []
                    self.tableView.reloadData()
                    self.nicknameLabel.text = "비회원님,"
                    self.userPostCount.text = "0가지"
                }
            } else {
                guard let currentUserUID = auth.currentUser?.uid else { return }
                PostManager.shared.userPosts = []
                PostManager.shared.laodUserPosts(currentUserUID: currentUserUID) { (success) in
                    if success {
                        DispatchQueue.main.async {
                            if let name = auth.currentUser?.displayName {
                                self.nicknameLabel.text = "\(name)님,"
                                self.userPostCount.text = "\(PostManager.shared.userPosts.count)가지"
                            } else {
                                self.nicknameLabel.text = "회원님,"
                                self.userPostCount.text = "0가지"
                            }
                            self.tableView.reloadData()
                        }
                    } else {
                        print("viewWillAppear - laodUserPosts failed")
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func navigationConfigureUI() {
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: emotionsTitle)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostManager.shared.userPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myPostCell", for: indexPath) as? MyPostTableViewCell else { return UITableViewCell() }
        let post = PostManager.shared.userPosts[indexPath.row]
        cell.updateUI(post: post)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "정리하기") { (_, indexPath) in
            let alert = UIAlertController(title: "감정 정리하기", message: "정리한 감정은 다시 복구할 수 없습니다. \n정리하시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "정리하기", style: .destructive) { (action) in
                postsRef.child(PostManager.shared.userPosts[indexPath.row].postID).removeValue()
                PostManager.shared.userPosts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.userPostCount.text = "\(PostManager.shared.userPosts.count)가지"
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        deleteAction.backgroundColor = UIColor(named: emotionLightGreen)
        return [deleteAction]
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("mypostSegue")
        if segue.identifier == "mypostSegue" {
            var post: Post! = nil
            var rowIndex = 0
            
            /// 버튼을 누른 경우..
            if let cell = (sender as! UIView).superview?.superview?.superview as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)!
                
                rowIndex = indexPath.row
            }
            else if let indexPath = tableView.indexPathForSelectedRow { // 셀 자체 선택?
                rowIndex = indexPath.row
            }
            
            post = PostManager.shared.userPosts[rowIndex]
            
            let vcDetail = segue.destination as! PostDetailViewController
            
            vcDetail.post = post
        }
    }
}
