//
//  PostDetailTableViewController.swift
//  Emotions
//
//  Created by Jungsang Lim on 2021/04/22.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    // 넘겨 받은 데이터
    var post: Post?
    var comment: Comment?
    
    
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var firstCardLabel: UILabel!
    @IBOutlet weak var secondCardLabel: UILabel!
    @IBOutlet weak var thirdCardLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 옵셔널 해제 : if let shadowing, forced unwrapping, guard let
        // 예외상황 적기 ?? 뒤에다가 "" 또는 다른 것
        
        // 넘겨 받은 포스트 풀기, 풀었는데 데이터가 있으면 아래를 수행하라
        if let post = post {

            firstCardLabel.text = post.firstCard?.title
            secondCardLabel.text = post.secondCard?.title
            thirdCardLabel.text = post.thirdCard?.title
            dateLabel.text = dateToDday(post: post)
            contentLabel.text = post.content
            
            
            updateUI()
            navigationConfigureUI()
        }


    }
    
    // MARK: - functions
    
    func updateUI() {
        
    }

    func navigationConfigureUI() {
        title = "Post Detail"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // 섹션은 1개
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // 여기서 어떻게 대입해야 해당 글의 코멘트의 개수만큼 읽어와서 대입할 수 있을까?
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 코멘트의 데이터 소스를 무엇을 읽어와야 할까?
        // let row = ???
        
        // reuseID 대입, 커스텀셀 파일 캐스팅
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell

        // 유저네임, 날짜, 댓글내용 대입
        //cell.commentUserNameLabel.text = row.userName
        //cell.commentDateLabel.text = "\(row.date)"
        //cell.commentContentLabel.text = row.content


        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
