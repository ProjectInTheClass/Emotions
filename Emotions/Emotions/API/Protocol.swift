//
//  Protocol.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/09.
//

import Foundation

protocol PostCellDelegate {
    func heartButtonTappedInCell(_ cell: PostTableViewCell, isSelected: Bool)
    func starButtonTappedInCell(_ cell: PostTableViewCell, isSelected: Bool)
    func commentButtonTappedInCell(_ cell: PostTableViewCell)
}
