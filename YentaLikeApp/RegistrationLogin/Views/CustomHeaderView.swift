//
//  CustomHeaderView.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/01.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {
    
    let profileImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "No Name"
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        
        nameLabel.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 0, height: 80))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
