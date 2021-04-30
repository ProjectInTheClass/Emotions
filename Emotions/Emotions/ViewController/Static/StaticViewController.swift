//
//  StaticViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/08.
//

import UIKit
import FirebaseAuth
import Charts
import Lottie

class StaticViewController: UIViewController, ChartViewDelegate {
    
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
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var emotionLottiView: AnimationView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfigureUI()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let currentUser = Auth.auth().currentUser else { return }
        self.userNicknameLabel.text = "\(currentUser.displayName ?? "비회원")님의"
        PostManager.shared.userPosts = []
        PostManager.shared.laodUserPosts(currentUserUID: currentUser.uid) { [weak self] in
            guard let self = self else { return }
            
            let userPosts = PostManager.shared.userPosts
            
            self.myPostsCardTypes = []
            self.sadnessCards = []
            self.joyCards = []
            self.angerCards = []
            self.disgustCards = []
            self.fearCards = []
            
            let userEmotionName = ["Joy", "Sadness", "Anger", "Disgust", "Fear"]
            let userEmotionCount =  self.myPostToStatic(posts: userPosts)
            let bestCardType = self.searchBestEmotion()
            
            self.view.backgroundColor = bestCardType.typeBackground
            self.setChart(dataPoints: userEmotionName, values: userEmotionCount)
        }
    }
    
    func configureUI() {
        let animation = Animation.named("28759-angry-emoji")
        emotionLottiView.animation = animation
        emotionLottiView.loopMode = .loop
        emotionLottiView.animationSpeed = 0.6
        emotionLottiView.backgroundColor = .clear
        emotionLottiView.contentMode = .scaleAspectFill
        emotionLottiView.play()
    }
    
    func lottieImageUpdateUI(){
        
    }
    
    private func searchBestEmotion() -> CARDTYPE {
        var typeDictionary: [Int:CARDTYPE] = [:]
        typeDictionary[joyCards.count] = .joy
        typeDictionary[sadnessCards.count] = .sadness
        typeDictionary[angerCards.count] = .anger
        typeDictionary[disgustCards.count] = .disgust
        typeDictionary[fearCards.count] = .fear
        let sortedDictionary = typeDictionary.sorted { $0.key > $1.key }
        let bestType = sortedDictionary.first?.value ?? .joy
        return bestType
    }
    
    private func setChart(dataPoints: [String], values: [Double]) {
        pieChart.delegate = self
        pieChart.backgroundColor = .clear
        
        var pieChartsDatas = [PieChartDataEntry]()
        
        for (index, value) in values.enumerated() {
            let pieChartData = PieChartDataEntry()
            
            if value == 0 {
                continue
            } else {
                pieChartData.y = value
                pieChartData.label = dataPoints[index]
                pieChartsDatas.append(pieChartData)
                let pieChartDataSet = PieChartDataSet(entries: pieChartsDatas, label: nil)
                let pieChartData = PieChartData(dataSet: pieChartDataSet)
                pieChartDataSet.colors = colorsOfCharts(values: values)
                pieChart.data = pieChartData
                
                let format = NumberFormatter()
                format.numberStyle = .none
                let formatter = DefaultValueFormatter(formatter: format)
                pieChartData.setValueFormatter(formatter)
            }
        }
        pieChart.isUserInteractionEnabled = true
        pieChart.noDataText = "데이터가 없습니다."
        pieChart.holeRadiusPercent = 0.4
        pieChart.holeColor = .clear
        pieChart.transparentCircleColor = UIColor.clear
    }
    
    private func colorsOfCharts(values: [Double]) -> [UIColor] {
        let userEmotionColor: [UIColor] = [
            UIColor(named: joyColor)!,
            UIColor(named: sadnessColor)!,
            UIColor(named: angerColor)!,
            UIColor(named: disgustColor)!,
            UIColor(named: fearColor)!
        ]
        var colorArray = [UIColor]()
        for index in 0..<values.count {
            if values[index] != 0 {
                colorArray.append(userEmotionColor[index])
            } else {
                continue
            }
        }
        return colorArray
    }
    
    private func navigationConfigureUI() {
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: emotionsTitle)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func myPostToStatic(posts: [Post]) -> [Double] {
        
        for post in posts {
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
        let myCount = myPostsCardTypes.count
        let joyCount = Double(100 * joyCards.count / myCount)
        let sadnessCount = Double(100 * sadnessCards.count / myCount)
        let angerCount = Double(100 * angerCards.count / myCount)
        let disgustCount = Double(100 * disgustCards.count / myCount)
        let fearCount = Double(100 * fearCards.count / myCount)
        return [joyCount, sadnessCount, angerCount, disgustCount, fearCount]
    }
}
