//
//  SelfIntroCell.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/01.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import UIKit

class SelfIntroCell: UITableViewCell, UITextViewDelegate {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18, weight: .light)
        tv.isEditable = true
        return tv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textView)
        textView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 200))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
