//
//  ReportController.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/03.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import UIKit

class ReportController: UIViewController {
    
    let progressLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.9298198819, green: 0.9006029963, blue: 0.9708290696, alpha: 0.5)
        label.numberOfLines = 0
        label.text = "ただいま仕掛り中・・・\n完成までもう少々お待ちを・・・・"
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        view.addSubview(progressLabel)
        progressLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 32, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 0))
    }
    
    fileprivate func setupNavigationBar(){
        navigationItem.title = "マッチングレポート"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09851664624, green: 0.2761102814, blue: 0.5600723167, alpha: 1)
    }
}
