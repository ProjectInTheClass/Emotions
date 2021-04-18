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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PostManager.shared.myHeartPosts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: myPostCell, for: indexPath) as? MyPostTableViewCell else { return UITableViewCell() }
        let myPost = PostManager.shared.myHeartPosts[indexPath.row]
        cell.detailTextLabel?.text = myPost.content
        cell.textLabel?.text = dateToDday(post: myPost)

        return cell
    }
  


}
