//
//  DetailHeaderView.swift
//  Emotions
//
//  Created by 박형석 on 2021/05/04.
//

import UIKit

class DetailHeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier: String = String(describing: self)
    
    var postHeaderView: UIView = {
       let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.47
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        return view
    }()
    
    var postContent: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.font = UIFont(name: "NanumGaRamYeonGgoc", size: 18)
        return label
    }()
    
    var firstCardLabel: UILabel = {
        let label = UILabel()
        let customFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.font = customFont
        label.font = UIFont(name: "NanumSquareB", size: 20)
        label.textColor = .white
        return label
    }()
    
    var secondCardLabel: UILabel = {
        let label = UILabel()
        let customFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.font = customFont
        label.font = UIFont(name: "NanumSquareB", size: 20)
        label.textColor = .white
        return label
    }()
    
    var thirdCardLabel: UILabel = {
        let label = UILabel()
        let customFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.font = customFont
        label.font = UIFont(name: "NanumSquareB", size: 20)
        label.textColor = .white
        return label
    }()
    
    var dateLabel: UILabel = {
       let label = UILabel()
        let customFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        label.font = customFont
        label.font = UIFont(name: "Sora", size: 17)
        return label
    }()
    
    var commentImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "comment")
        return imageView
    }()
    
    var commentCountLabel: UILabel = {
       let label = UILabel()
        let customFont = UIFont.systemFont(ofSize: 15, weight: .light)
        label.font = UIFont(name: "Sora", size: 15)
        label.font = customFont
        return label
    }()
    
    var starImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "StarSelect")
        return imageView
    }()
    
    var starPointLabel: UILabel = {
       let label = UILabel()
        let customFont = UIFont.systemFont(ofSize: 15, weight: .light)
        label.font = UIFont(name: "Sora", size: 15)
        label.font = customFont
        return label
    }()
    
    var separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9074590774, green: 0.9074590774, blue: 0.9074590774, alpha: 1)
        return view
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configurationUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateUI(post: Post, comments: [Comment]) {
        
        postHeaderView.backgroundColor = post.firstCard?.cardType.typeColor
        
        let attributedString = NSMutableAttributedString(string: post.content)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        postContent.attributedText = attributedString
        
        if let firstCard = post.firstCard {
            firstCardLabel.text = "#\(firstCard.title)"
            firstCardLabel.isHidden = false
        } else {
            firstCardLabel.isHidden = true
        }
        
        if let secondCard = post.secondCard {
            secondCardLabel.text = "#\(secondCard.title)"
            secondCardLabel.isHidden = false
        } else {
            secondCardLabel.isHidden = false
        }
        
        if let thirdCard = post.thirdCard {
            thirdCardLabel.text = "#\(thirdCard.title)"
            thirdCardLabel.isHidden = false
        } else {
            thirdCardLabel.isHidden = false
        }

        dateLabel.text = dateToDday(post: post)
        commentCountLabel.text = "댓글 \(comments.count)개"
        starPointLabel.text = "추천 \(post.starPoint)개"
    }
    
    func configurationUI() {
        
        contentView.backgroundColor = #colorLiteral(red: 0.9870721726, green: 0.9870721726, blue: 0.9870721726, alpha: 1)
        
        let cardStackView = UIStackView(arrangedSubviews: [firstCardLabel, secondCardLabel, thirdCardLabel])
        cardStackView.alignment = .fill
        cardStackView.axis = .horizontal
        cardStackView.spacing = 5
        cardStackView.distribution = .fillProportionally
        
        let stateStackView = UIStackView(arrangedSubviews: [commentImage, commentCountLabel, starImage, starPointLabel])
        stateStackView.alignment = .fill
        stateStackView.axis = .horizontal
        stateStackView.spacing = 5
        stateStackView.distribution = .fill
        
        contentView.addSubview(postHeaderView)
        contentView.addSubview(postContent)
        postHeaderView.addSubview(cardStackView)
        postHeaderView.addSubview(dateLabel)
        contentView.addSubview(stateStackView)
        contentView.addSubview(separatorView)
        
        starImage.anchor(width: 20, height: 20)
        commentImage.anchor(width: 20, height: 20)
        separatorView.anchor(height: 1)
        
        cardStackView.anchor(left: postHeaderView.leftAnchor, bottom: postHeaderView.bottomAnchor, paddingLeft: 20, paddingBottom: 20)
        dateLabel.anchor(left: postHeaderView.leftAnchor, bottom: cardStackView.topAnchor, paddingLeft: 20, paddingBottom: 10)
        postHeaderView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: postContent.topAnchor, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 40, paddingRight: 0, height: 180)
        postContent.anchor(left: contentView.leftAnchor, right: contentView.rightAnchor, paddingLeft: 25, paddingRight: 25)
        stateStackView.anchor(top: postContent.bottomAnchor, left: postContent.leftAnchor, bottom: contentView.bottomAnchor,  paddingTop: 40, paddingLeft: 0, paddingBottom: 20)
        separatorView.anchor(left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
}
