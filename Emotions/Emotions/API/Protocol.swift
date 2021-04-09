//
//  Protocol.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation
import UIKit

protocol PostCellDelegate {
    func heartButtonTappedInCell(_ sender: UIButton, isSelected: Bool)
    func starButtonTappedInCell(_ sender: UIButton, isSelected: Bool)
    func commentButtonTappedInCell(_ sender: UIButton)
}
