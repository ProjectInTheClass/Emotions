//
//  StarButton.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/10.
//

import Foundation
import UIKit

class StarButton: UIButton {
    
    var isActivated: Bool = false
    let activeButtonImage = UIImage(named: "StarSelect")
    let inActiveButtonImage = UIImage(named: "star")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
    }
    
    func setState(_ newValue: Bool) {
        self.isActivated = newValue
        self.setImage(self.isActivated ? activeButtonImage : inActiveButtonImage, for: .normal)
    }
    
    @objc func starButtonTapped() {
        self.isActivated.toggle()
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            let image = self.isActivated ? self.activeButtonImage : self.inActiveButtonImage
            self.transform = self.transform.scaledBy(x: 0.85, y: 0.85)
            self.setImage(image, for: .normal)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
            
        }
        
        
    }
    
}
