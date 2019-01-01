//
//  SwipeResultView.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/29.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit

class SwipeResultView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray
        //今日のレコメンドを全て確認しましたとかその辺を全部入れこむ。
        //全て普通にstaticでswipeControllerから値をもらうだけ
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
