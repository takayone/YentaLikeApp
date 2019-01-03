//
//  MessageCell.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/03.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    var user: User!{
        didSet{
            nameLabel.text = user.fullName
            companyProfessionLabel.text = user.companyName + "/" + user.profession
            
            if let urlString = user.imageUrl as? String,let url = URL(string: urlString){
                profileImageView.sd_setImage(with: url)
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "KEISUKE HONDA"
        return label
    }()
    
    let companyProfessionLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST株式会社/エンジニア"
        label.numberOfLines = 0
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST TESTTEST Test TESt testTest....."
        label.alpha = 0.5
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 60, height: 60))
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        addSubview(companyProfessionLabel)
        companyProfessionLabel.anchor(top: nameLabel.bottomAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 4, left: 8, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        
        addSubview(messageLabel)
        messageLabel.anchor(top: companyProfessionLabel.bottomAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 4, left: 8, bottom: 0, right: 0), size: .init(width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
