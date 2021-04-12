//
//  CardCollectionViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/11.
//

import UIKit
import PanModal
import BetterSegmentedControl

private let reuseIdentifier = "cardCell"

class CardCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cards = CardManager.shared.cards
    var selectedCards:[Card] = []
    var completionHandler: (([Card])->Void)?
    let completeButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        button.layer.cornerRadius = 8
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
    
    var dictionarySelectedIndexPath: [IndexPath:Bool] = [:] {
        didSet {
            if !dictionarySelectedIndexPath.isEmpty {
                completeButton.isHidden = false
                backgroundView.isHidden = false
            } else {
                completeButton.isHidden = true
                backgroundView.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardTypeSegmentControl: BetterSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControlConfigureUI()
        buttonUI()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if dictionarySelectedIndexPath.count == 3 {
            print(dictionarySelectedIndexPath.count)
            print("카드는 3개 까지만 선택할 수 있습니다.")
            return
        } else {
            dictionarySelectedIndexPath[indexPath] = true
            print(dictionarySelectedIndexPath.count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        dictionarySelectedIndexPath[indexPath] = nil
        print(dictionarySelectedIndexPath.count)
    }
    
    // MARK: - UI Fucntions
    
    func buttonUI(){
        view.addSubview(backgroundView)
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        completeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        completeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        completeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.heightAnchor.constraint(equalToConstant: 52).isActive = true
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
        switch sender.index {
        case 0:
            print("전체")
        case 1:
            print("기쁨")
        case 2:
            print("슬픔")
        case 3:
            print("분노")
        case 4:
            print("불쾌")
        case 5:
            print("두려움")
        default:
            break
        }
    }
    
    @objc func selectCardButtonTapped() {
        var selectedIndexPath: [IndexPath] = []
        for (key, value) in dictionarySelectedIndexPath {
            if value {
                selectedIndexPath.append(key)
            }
        }
        
        for i in selectedIndexPath.sorted(by: <) {
            selectedCards.append(cards[i.item])
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
        return .maxHeightWithTopInset(150)
    }
    var anchorModalToLongForm: Bool {
        return true
    }
}

