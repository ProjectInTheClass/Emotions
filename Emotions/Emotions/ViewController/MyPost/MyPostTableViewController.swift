//
//  MyPostTableViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/16.
//

import UIKit

class MyPostTableViewController: UITableViewController {
    
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
        PostManager.shared.laodUserPosts { (success) in
            if success {
                DispatchQueue.main.async {
                    if let name = AuthManager.shared.currentUser?.displayName {
                        self.nicknameLabel.text = "\(name)님,"
                    } else {
                        self.nicknameLabel.text = "비회원님,"
                    }
                    
                    self.userPostCount.text = "\(PostManager.shared.userPosts.count)가지"
                    self.tableView.reloadData()
                }
            } else {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AuthManager.shared.checkLogin { success in
            if success {
                DispatchQueue.main.async {
                    PostManager.shared.userPosts = []
                    self.nicknameLabel.text = "비회원님,"
                    self.userPostCount.text = "0가지"
                }
            } else {
                print("유저 자동 로그인")
            }
        }
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
        if segue.identifier == "mypostSegue" {
//            guard let indexPath = tableView.indexPathForSelectedRow else {
//                print("indexPathForSelectedRow")
//                return }
//            let post = DataManager.shared.latestposts[indexPath.row]
//            guard let postDetailViewController = segue.destination as? PostDetailViewController else { return }
//            postDetailViewController.post = post
        }
    }


}
