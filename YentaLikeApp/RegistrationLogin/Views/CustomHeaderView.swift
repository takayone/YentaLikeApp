//
//  CustomHeaderView.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/01.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
