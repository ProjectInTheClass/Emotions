//
//  SecondPostViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/19.
//

import UIKit
import BetterSegmentedControl

class SecondPostViewController: UIViewController {
    
    @IBOutlet weak var myPostSegmentControl: BetterSegmentedControl!
    @IBOutlet weak var myPostContainer: UIView!
    @IBOutlet weak var heartPostContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControlConfigureUI()
        myPostContainer.isHidden = false
        heartPostContainer.isHidden = true
    }
    
    func navigationConfigureUI() {
        navigationItem.title = ""
//        let addButton = UIBarButtonItem(customView: addPostButton)
//        let searchButton = UIBarButtonItem(customView: searchPostButton)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: emotionsTitle)
//        navigationItem.rightBarButtonItems = [addButton, searchButton]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    func segmentedControlConfigureUI() {
        myPostSegmentControl.indicatorViewBackgroundColor = UIColor(named: "emotionLightGreen")
        myPostSegmentControl.cornerRadius = 8
        myPostSegmentControl.backgroundColor = .white
        myPostSegmentControl.alwaysAnnouncesValue = true
        myPostSegmentControl.segments = LabelSegment.segments(withTitles: ["나의 편지", "좋아요"],
                                                               normalTextColor: UIColor(red: 0.48, green: 0.48, blue: 0.51, alpha: 1.00))
        myPostSegmentControl.addTarget(self, action: #selector(myPostSegmenttedControlValueChanged(_:)), for: .valueChanged)
    }
    
    
    @objc func myPostSegmenttedControlValueChanged(_ sender: BetterSegmentedControl) {
        // 다양한 레포에 따른 반응을 구현하도록 임시저장소를 만들어야 한다. 단순히 array를 바꿔가며 사용하는게 좋은가? 아니면 다른 방법이 있을가 고민해봐야 한다.
        if sender.index == 0 {
            myPostSegmentControl.indicatorViewBackgroundColor = UIColor(named: emotionLightGreen)
            myPostContainer.isHidden = false
            heartPostContainer.isHidden = true
        } else {
            myPostSegmentControl.indicatorViewBackgroundColor = UIColor(named: emotionLightPink)
            myPostContainer.isHidden = true
            heartPostContainer.isHidden = false
        }
    }

}
