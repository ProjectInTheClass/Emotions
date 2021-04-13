//
//  PostDetailViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/13.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    var post: Post?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var firstCardLabel: UILabel!
    @IBOutlet weak var secondCardLabel: UILabel!
    @IBOutlet weak var thirdCardLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var commentsTextField: UITextField?
    @IBOutlet weak var firstCardColorBar: UIView!
    @IBOutlet weak var secondCardColorBar: UIView!
    @IBOutlet weak var thirdCardColorBar: UIView!
    
    var detailCompletionHandler: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        navigationConfigureUI()
    }
    
    private func updateUI() {
        guard let post = post else { return }
        dateLabel.text = dateToDday(post: post)
        if let firstCard = post.firstCard {
            firstCardLabel.text = "#\(firstCard.title)"
            firstCardLabel.textColor = firstCard.cardType.typeColor
            firstCardColorBar.backgroundColor = firstCard.cardType.typeColor
        } else {
            firstCardLabel.isHidden = true
            firstCardColorBar.isHidden = true
        }
        
        if let secondCard = post.secondCard {
            secondCardLabel.text = "#\(secondCard.title)"
            secondCardLabel.textColor = secondCard.cardType.typeColor
            secondCardColorBar.backgroundColor = secondCard.cardType.typeColor
        } else {
            secondCardLabel.isHidden = true
            secondCardColorBar.isHidden = true
        }
        
        if let thirdCard = post.thirdCard {
            thirdCardLabel.text = "#\(thirdCard.title)"
            thirdCardLabel.textColor = thirdCard.cardType.typeColor
            thirdCardColorBar.backgroundColor = thirdCard.cardType.typeColor
        } else {
            thirdCardLabel.isHidden = true
            thirdCardColorBar.isHidden = true
        }
        contentLabel.text = post.content
    }

    func navigationConfigureUI() {
        title = "Post Detail"
        navigationController?.navigationBar.tintColor = .darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "AppleColorEmoji", size: 21)!]
    }
    

}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentManager.shared.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        let comment = CommentManager.shared.comments[indexPath.row]
        cell.updateUI(comment: comment)
        return cell
    }
    
    
}
