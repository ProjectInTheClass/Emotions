//
//  MyPostTableViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/16.
//

import UIKit

class MyPostTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfigureUI()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PostManager.shared.userPosts = []
        PostManager.shared.laodUserPosts { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                
            }
        }
    }
    
    
    func navigationConfigureUI() {
        navigationItem.title = ""
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
