//
//  SwipeController.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/29.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit

class SwipeController: UIViewController {
    
    var users = [User]()

    let statusBars = UIView()
    let cardDeckView: UIView = {
        let view = SwipeResultView()
        //新しいViewファイルを用意してそこで全てのレコメンドを確認しましたとかその辺を入れ込む
        return view
    }()

//    let disLikeButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("興味なし", for: .normal)
//        button.backgroundColor = .lightGray
//        return button
//    }()
//
//    let likeButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("興味あり", for: .normal)
//        button.backgroundColor = .lightGray
//        return button
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        (0..<5).forEach { (_) in
            let cardView = CardView()
            cardDeckView.addSubview(cardView)
            cardDeckView.sendSubviewToBack(cardView)
            cardView.fillSuperview()
        }
 
    }
    
    
    
    fileprivate func setupLayout(){
        
        view.backgroundColor = .white
        statusBars.backgroundColor = .blue
        
//        let buttonStackViews = UIStackView(arrangedSubviews: [likeButton, disLikeButton])
//        buttonStackViews.axis = .horizontal
//        buttonStackViews.spacing = 8
//        buttonStackViews.distribution = .fillEqually
//
//        let overallStackViews = UIStackView(arrangedSubviews: [statusBars, cardDeckView, buttonStackViews])
//        overallStackViews.axis = .vertical
//        overallStackViews.distribution = .fillEqually
//
//        view.addSubview(overallStackViews)
//        overallStackViews.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
//
        view.addSubview(statusBars)
        view.addSubview(cardDeckView)
//        view.addSubview(disLikeButton)
//        view.addSubview(likeButton)

        statusBars.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 4) )
        cardDeckView.anchor(top: statusBars.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
//        disLikeButton.anchor(top: cardDeckView.bottomAnchor, leading: nil, bottom: nil, trailing: view.centerXAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 8), size: .init(width: 100, height: 100))
//        likeButton.anchor(top: cardDeckView.bottomAnchor, leading: view.centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 8, bottom: 0, right: 0), size: .init(width: 100, height: 100))
        
        
    }
    
    fileprivate func setupCardView() {

    }
}
