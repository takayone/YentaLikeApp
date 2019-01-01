//
//  SettingsCell.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/01.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import UIKit

class NamingCell: UITableViewCell {
    
    let textField: CustomTextField = {
        let tf = CustomTextField(padding: 16, height: 60)
        tf.placeholder = "名前を入れてください"
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
