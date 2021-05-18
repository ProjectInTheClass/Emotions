//
//  EULAViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/05/18.
//

import UIKit

class EULAViewController: UIViewController {
    
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var disagreeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        agreeButton.layer.cornerRadius = 10
        disagreeButton.layer.cornerRadius = 10
        
    }
    
    @IBAction func disagreeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
