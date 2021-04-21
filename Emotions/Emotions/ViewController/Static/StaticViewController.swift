//
//  StaticViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/08.
//

import UIKit

class StaticViewController: UIViewController {
   
    var myPostsCardTypes = [CARDTYPE]()
    var sadnessCards = [CARDTYPE]()
    var joyCards = [CARDTYPE]()
    var angerCards = [CARDTYPE]()
    var disgustCards = [CARDTYPE]()
    var fearCards = [CARDTYPE]()
    
    let emotionsTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainLogo")
        return imageView
    }()
    
    @IBOutlet weak var joyLabel: UILabel!
    @IBOutlet weak var sadnessLabel: UILabel!
    @IBOutlet weak var angerLabel: UILabel!
    @IBOutlet weak var disgustLabel: UILabel!
    @IBOutlet weak var fearLabel: UILabel!
    
    @IBOutlet weak var joyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sadnessViewHeight: NSLayoutConstraint!
    @IBOutlet weak var angerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var disgustViewLabel: NSLayoutConstraint!
    @IBOutlet weak var fearViewLabel: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfigureUI()
        PostManager.shared.userPosts = []
        PostManager.shared.laodUserPosts { (success) in
            if success {
                self.myPostToCardtype()
                self.updateUI()
            } else {
                
            }
        }

    }
    
    func updateUI(){
        let myCount = myPostsCardTypes.count
        let joyCount = joyCards.count
        joyLabel.text = "\(Int(100 * joyCount / myCount))%"
        joyViewHeight.constant = CGFloat(200 * joyCount / myCount)
        
        let sadnessCount = sadnessCards.count
        sadnessLabel.text = "\(Int(100 * sadnessCount / myCount))%"
        sadnessViewHeight.constant = CGFloat(200 * sadnessCount / myCount)
        
        let angerCount = angerCards.count
        angerLabel.text = "\(Int(100 * angerCount / myCount))%"
        angerViewHeight.constant = CGFloat(200 * angerCount / myCount)
        
        let disgustCount = disgustCards.count
        disgustLabel.text = "\(Int(100 * disgustCount / myCount))%"
        disgustViewLabel.constant = CGFloat(200 * disgustCount / myCount)
        
        let fearCount = fearCards.count
        fearLabel.text = "\(Int(100 * fearCount / myCount))%"
        fearViewLabel.constant = CGFloat(200 * fearCount / myCount)
    }
    
    func navigationConfigureUI() {
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: emotionsTitle)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func myPostToCardtype() {
        for post in PostManager.shared.userPosts {
            if let firstCard = post.firstCard {
                myPostsCardTypes += [firstCard.cardType]
            }
            if let secondCard = post.secondCard {
                myPostsCardTypes += [secondCard.cardType]
            }
            if let thirdCard = post.thirdCard {
                myPostsCardTypes += [thirdCard.cardType]
            }
        }
        
        for type in myPostsCardTypes {
            switch type {
            case .joy:
                joyCards += [type]
            case .sadness:
                sadnessCards += [type]
            case .disgust:
                disgustCards += [type]
            case .anger:
                angerCards += [type]
            case .fear:
                fearCards += [type]
            }
        }
    }
}
