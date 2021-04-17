//
//  CardCollectionViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/11.
//

import UIKit
import PanModal
import BetterSegmentedControl

class CardCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cards = CardManager.shared.cards
    var completionHandler: (([Card])->Void)?
    
    let completeButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor(named: "emotionLightGreen")
        button.layer.cornerRadius = 20
        let configTitle = NSAttributedString(text: "완료", aligment: .center, color: .white)
        button.setAttributedTitle(configTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight:.black)
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 1.0
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 10
        button.isHidden = true
        return button
    }()
    
    let backgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.8
        view.isHidden = true
        return view
    }()
    
    var selectedCards:[Card] = []
    
    var selectedCardsDic: [String:Card] = [:] {
        didSet {
            if !selectedCardsDic.isEmpty {
                completeButton.isHidden = false
                backgroundView.isHidden = false
            } else {
                completeButton.isHidden = true
                backgroundView.isHidden = true
            }
        }
    }
    
    var bottomPadding: CGFloat?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardTypeSegmentControl: BetterSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControlConfigureUI()
        buttonUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cards.map { $0.isSelected = false }
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        cell.updateUI(card: cards[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width / 2 - 30
        let height: CGFloat = width
        let cellSize = CGSize(width: width, height: height)
        return cellSize
    }
    
    // 선택 후에 다시 복귀했을 때, 바로 취소할 수가 없음. 한번 더 누르거나, 4장 선택으로 인식해서 deselect로 가지 않음. 예상으로는 처음 CardVC에 들어갔을 때, 선택된게 없기 때문에 당연히 deselect가 안먹을 듯. 그럼... else 구문에도 deselect 넣어주면 안되나? 그럼 3이하에서는 더블클릭, 3이상에서는 실행될듯함. 준비하고 실행
    // => 관련해서 수정은 해놨는데, 다시 해보니 일단은 문제가 없다... 혹시 문제 생기면 다시 수정
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let item = collectionView.cellForItem(at: indexPath)
        if item?.isSelected ?? false {
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            if selectedCardsDic.count < 3 {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                let selectedCard = cards[indexPath.item]
                selectedCard.isSelected = true
                selectedCardsDic[selectedCard.id] = selectedCard
                collectionView.reloadItems(at: [indexPath])
                return true
            } else {
                collectionView.deselectItem(at: indexPath, animated: true)
                print("3장의 카드만 선택해 주세요.")
                return false
            }
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCard = cards[indexPath.item]
        selectedCard.isSelected = false
        selectedCardsDic[selectedCard.id] = nil
        collectionView.reloadItems(at: [indexPath])
    }
    
    // MARK: - UI Fucntions
    
    func buttonUI(){
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
        
        view.addSubview(backgroundView)
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        completeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        completeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        completeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20 - bottomPadding!).isActive = true
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        backgroundView.topAnchor.constraint(equalTo: completeButton.centerYAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        completeButton.startAnimatingPressActions()
        collectionView.allowsMultipleSelection = true
        completeButton.addTarget(self, action: #selector(selectCardButtonTapped), for: .touchUpInside)
    }
    
    func segmentedControlConfigureUI() {
        cardTypeSegmentControl.indicatorViewBackgroundColor = UIColor(named: "emotionLightGreen")
        cardTypeSegmentControl.cornerRadius = cardTypeSegmentControl.frame.height / 2
        cardTypeSegmentControl.backgroundColor = .white
        cardTypeSegmentControl.alwaysAnnouncesValue = true
        cardTypeSegmentControl.segments = LabelSegment.segments(withTitles: ["전체", "기쁨", "슬픔", "분노", "불쾌", "두려움"], normalTextColor: UIColor(red: 0.48, green: 0.48, blue: 0.51, alpha: 1.00))
        cardTypeSegmentControl.addTarget(self, action: #selector(cardSegmenttedControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func cardSegmenttedControlValueChanged(_ sender: BetterSegmentedControl) {
        let wholeCards = CardManager.shared.cards
        switch sender.index {
        case 0:
            completeButton.backgroundColor = UIColor(named: "emotionLightGreen")
            cardTypeSegmentControl.indicatorViewBackgroundColor = UIColor(named: "emotionLightGreen")
            self.cards = wholeCards
        case 1:
            completeButton.backgroundColor = UIColor(named: "joy")
            cardTypeSegmentControl.indicatorViewBackgroundColor = UIColor(named: "joy")
            self.cards = CardManager.shared.fetchJoyCards(cards: wholeCards)
        case 2:
            completeButton.backgroundColor = UIColor(named: "sadness")
            cardTypeSegmentControl.indicatorViewBackgroundColor = UIColor(named: "sadness")
            self.cards = CardManager.shared.fetchSadnessCards(cards: wholeCards)
        case 3:
            completeButton.backgroundColor = UIColor(named: "anger")
            cardTypeSegmentControl.indicatorViewBackgroundColor = UIColor(named: "anger")
            self.cards = CardManager.shared.fetchAngerCards(cards: wholeCards)
        case 4:
            completeButton.backgroundColor = UIColor(named: "disgust")
            cardTypeSegmentControl.indicatorViewBackgroundColor = UIColor(named: "disgust")
            self.cards = CardManager.shared.fetchDisgustCards(cards: wholeCards)
        case 5:
            completeButton.backgroundColor = UIColor(named: "fear")
            cardTypeSegmentControl.indicatorViewBackgroundColor = UIColor(named: "fear")
            self.cards = CardManager.shared.fetchFearCards(cards: wholeCards)
        default:
            break
        }
        collectionView.reloadData()
    }
    
    @objc func selectCardButtonTapped() {
        
        for (_, value) in selectedCardsDic {
            selectedCards.append(value)
        }
        
        if let completionhandler = completionHandler {
            completionhandler(selectedCards)
        }

        self.dismiss(animated: true, completion: nil)
    }
}

extension CardCollectionViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return collectionView
    }
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(130)
    }
    var anchorModalToLongForm: Bool {
        return true
    }
}

