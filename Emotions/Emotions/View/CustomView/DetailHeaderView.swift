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
        return view
    }()
    
    var postContent: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var firstCardLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var secondCardLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var thirdCardLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var dateLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    var informationStackView: UIStackView = {
       let stack = UIStackView()
       
        return stack
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configurationSubview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configurationAutoLayout()
    }
    
    func updateUI(post: Post) {
        postHeaderView.backgroundColor = post.firstCard?.cardType.typeColor
        postContent.text = post.content
        firstCardLabel.text = post.firstCard?.title
        secondCardLabel.text = post.secondCard?.title
        thirdCardLabel.text = post.thirdCard?.title
        dateLabel.text = dateToDdayForMyPost(post: post)
    }
    
    func configurationSubview() {
        contentView.addSubview(postHeaderView)
        contentView.addSubview(postContent)
        contentView.addSubview(firstCardLabel)
        contentView.addSubview(secondCardLabel)
        contentView.addSubview(thirdCardLabel)
        contentView.addSubview(dateLabel)
    }
    
    func configurationAutoLayout() {
        postContent.translatesAutoresizingMaskIntoConstraints = false
        postHeaderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        postHeaderView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        postHeaderView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        postHeaderView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        postContent.translatesAutoresizingMaskIntoConstraints = false
        postContent.topAnchor.constraint(equalTo: postHeaderView.bottomAnchor, constant: 10).isActive = true
        postContent.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
        postContent.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25).isActive = true
        postContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
}
