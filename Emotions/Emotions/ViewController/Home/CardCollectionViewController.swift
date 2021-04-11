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
    var dictionarySelectedIndexPath: [IndexPath:Bool] = [:]
    var completionHandler: (([Card])->Void)?
    let completeButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        let configTitle = NSAttributedString(text: "완료", aligment: .center, color: .white)
        button.setAttributedTitle(configTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight:.black)
        return button
    }()
    
    let buttonBackgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.9
        return view
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardTypeSegmentControl: BetterSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControlConfigureUI()
        collectionView.allowsMultipleSelection = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    
        buttonBackgroundView.frame = CGRect(x: 20, y: view.bounds.height - 52 - view.safeAreaInsets.bottom - 10, width: view.bounds.width - 40, height: 52 + view.safeAreaInsets.bottom + 34)
        buttonBackgroundView.layer.cornerRadius = CornerRadius.myValue
        completeButton.frame = CGRect(x: 20, y: view.bounds.height - 52 - view.safeAreaInsets.bottom - 10, width: view.bounds.width - 40, height: 52)
        
        view.addSubview(buttonBackgroundView)
        view.addSubview(completeButton)
     
        completeButton.addTarget(self, action: #selector(selectCardButtonTapped), for: .touchUpInside)
        completeButton.startAnimatingPressActions()
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
        let width: CGFloat = (collectionView.bounds.width) / 3 - 20
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
        return .maxHeightWithTopInset(200)
    }
    var anchorModalToLongForm: Bool {
        return true
    }
}

