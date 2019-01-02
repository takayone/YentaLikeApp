//
//  CustomLikeDislikeView.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/02.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import UIKit

class CustomLikeDislikeView: UIView {
    
    let textLabel: UILabel = {
        let label = UILabel()
        let attrbutedText = NSMutableAttributedString(string: "○", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30, weight: .bold)])
        attrbutedText.append(NSAttributedString(string: "\n興味あり", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        label.attributedText = attrbutedText
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textLabel)
        textLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
