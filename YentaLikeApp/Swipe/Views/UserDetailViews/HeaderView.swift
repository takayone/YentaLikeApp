//
//  HeaderView.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/30.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    var user: User!{
        didSet{
            guard let imageUrl = user.imageUrl as? String, let url = URL(string: imageUrl) else {return}
            imageView.sd_setImage(with: url)
            
            infoLabel.attributedText = user.sendUserInfo()
            
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40
        return iv
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Takahito Yoneda(27)\nTEST株式会社\n代表取締役社長"
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        addSubview(imageView)
        addSubview(infoLabel)
        
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        infoLabel.anchor(top: topAnchor, leading: imageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 0, height: 80))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
