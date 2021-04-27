//
//  StaticViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/08.
//

import UIKit
import FirebaseAuth
import Charts

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
    
    @IBOutlet weak var pieChart: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfigureUI()
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        PostManager.shared.userPosts = []
        PostManager.shared.laodUserPosts(currentUserUID: currentUserUID) { (success) in
            if success {
                self.myPostToCardtype()
                self.updateUI()
            } else {
                
            }
        }

    }
    
    func configureUI(){
        pieChart.backgroundColor = .clear
    }
    
    func updateUI(){
//        let myCount = myPostsCardTypes.count
//        let joyCount = joyCards.count
//        let sadnessCount = sadnessCards.count
//        let angerCount = angerCards.count
//        let disgustCount = disgustCards.count
//        let fearCount = fearCards.count
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
