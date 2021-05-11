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
import GoogleMobileAds

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
        imageView.alpha = 0.8
        return imageView
    }()
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var emotionLottiView: AnimationView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userEmotionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfigureUI()
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("updateTableView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emotionLottiView.play()
        updateUI()
    }
    
    @objc private func updateUI() {
        if let currentUser = Auth.auth().currentUser {
            let myheartPosts = PostManager.shared.myHeartPosts
            let userPosts = PostManager.shared.userPosts
            let staticPosts = myheartPosts + userPosts
            
            if self.myPostsCardTypes.count == 0 {
                self.myPostsCardTypes = [.joy]
            } else {
                self.myPostsCardTypes = []
            }
            
            self.sadnessCards = []
            self.joyCards = []
            self.angerCards = []
            self.disgustCards = []
            self.fearCards = []
            
            let userEmotionName = ["Joy", "Sadness", "Anger", "Disgust", "Fear"]
            let userEmotionCount =  self.myPostToStatic(posts: staticPosts)
            let bestCardType = self.searchBestEmotion()
            self.pieChart.isHidden = false
            self.updateLottieUI(emoji: bestCardType.typeEmoji)
            self.userNicknameLabel.text = currentUser.displayName
            self.userEmotionLabel.text = "'\(bestCardType.typeTitle)'"
            self.setChart(dataPoints: userEmotionName, values: userEmotionCount)
        } else {
            DispatchQueue.main.async {
                PostManager.shared.userPosts = []
                self.view.backgroundColor = .white
                self.userNicknameLabel.text = "비회원"
                self.userEmotionLabel.text = " - "
                self.pieChart.isHidden = true
            }
        }
    }
    
    func updateLottieUI(emoji: String) {
        let animation = Animation.named(emoji)
        emotionLottiView.animation = animation
        emotionLottiView.play()
        emotionLottiView.loopMode = .loop
        emotionLottiView.animationSpeed = 0.6
        emotionLottiView.backgroundColor = .clear
        emotionLottiView.contentMode = .scaleAspectFill
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
        pieChart.holeRadiusPercent = 0.43
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
