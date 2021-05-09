//
//  MyPostTableViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/16.
//

import UIKit
import FirebaseAuth

class MyPostTableViewController: UITableViewController {
    
    let emotionsTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainLogo")
        imageView.alpha = 0.8
        return imageView
    }()
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var userPostCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfigureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("updateTableView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    @objc private func updateUI() {
        if let currentUser = Auth.auth().currentUser {
            self.updateHeaderView(currentUser: currentUser)
        } else {
            DispatchQueue.main.async {
                PostManager.shared.userPosts = []
                self.tableView.reloadData()
                self.nicknameLabel.text = "비회원"
                self.userPostCount.text = "0가지"
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
    
    private func updateHeaderView(currentUser: User) {
        DispatchQueue.main.async {
            if let name = currentUser.displayName {
                self.nicknameLabel.text = name
                self.userPostCount.text = "\(PostManager.shared.userPosts.count)가지"
            } else {
                self.nicknameLabel.text = "회원님,"
                self.userPostCount.text = "0가지"
            }
            self.tableView.reloadData()
        }
    }
    
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
            let alert = UIAlertController(title: "감정 정리하기", message: "흘러갈 감정들에게 한 마디 남겨주세요.\n*정리한 감정은 복구되지 않습니다.\n신중하게 결정해주세요:)", preferredStyle: .alert)
            alert.addTextField { textfield in
                textfield.layer.cornerRadius = 10
                textfield.placeholder = "없으시다면 정리하기 버튼만 누르세요:)"
            }
            let okAction = UIAlertAction(title: "정리하기", style: .destructive) { (action) in
                postsRef.child(PostManager.shared.userPosts[indexPath.row].postID).removeValue()
                PostManager.shared.userPosts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
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
            guard let indexPath = tableView.indexPathForSelectedRow else {
                print("indexPathForSelectedRow")
                return }
            let post = PostManager.shared.userPosts[indexPath.row] //userPosts = PostManager 참고
            guard let postDetailViewController = segue.destination as? PostDetailViewController else { return }
            postDetailViewController.post = post
        }
    }
}
