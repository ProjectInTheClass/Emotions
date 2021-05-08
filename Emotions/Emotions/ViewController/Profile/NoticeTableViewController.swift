//
//  NoticeTableViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/05/08.
//

import UIKit

class NoticeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return NoticeManager.notices.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath)
        let notice = NoticeManager.notices[indexPath.row]
        cell.textLabel?.text = notice.title
        cell.detailTextLabel?.text = notice.date

        return cell
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC" {
            let vc = segue.destination as! NoticeDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let notice = NoticeManager.notices[indexPath.row]
            vc.notice = notice
        }
    }

}
