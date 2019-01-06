//
//  MatchView.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/06.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase

class MatchView: UIView {
    
    var currentUser: User!{
        didSet{
            
            if let currentUserImageString = currentUser.imageUrl as? String, let url = URL(string: currentUserImageString){
                currentUserImageView.sd_setImage(with: url)
            }
        }
    }
    
    var cardUID: String!{
        didSet{
            
            let ref = Firestore.firestore().collection("users").document(cardUID)
            ref.getDocument { (snapshot, err) in
                if let err = err{
                    print("failed to fetch CardView User", err)
                    return
                }
                
                guard let dictionary:[String: Any] = snapshot?.data() else {return}
                let cardUser = User(dictionary: dictionary)
                
                self.descriptionLabel.text = "あなたと\(cardUser.fullName ?? "")さんは\nマッチングしました"
                self.descriptionLabel.alpha = 1
                
                if let cardUserImageString = cardUser.imageUrl as? String, let url = URL(string: cardUserImageString){
                    self.cardUserImageView.sd_setImage(with: url)
                    self.cardUserImageView.alpha = 1
                    self.currentUserImageView.alpha = 1
                }
                
            }
        }
    }
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "あなたとXさんはマッチングしました"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.alpha = 0
        return imageView
    }()
    
    fileprivate let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("メッセージを送る", for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    @objc fileprivate func handleSendMessage(){
        print("これ、多分デリゲートメソッドで一度swipecontrollerに戻してそしてマッチングコントローラに行かせるのが良い。ただ、tabBarで行けるのか？")
    }
    
    fileprivate let keepSwipingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("スワイプを続ける", for: .normal)
        button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    fileprivate let cardUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.alpha = 0
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurView()
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        
        addSubview(descriptionLabel)
        addSubview(currentUserImageView)
        addSubview(cardUserImageView)
        addSubview(sendMessageButton)
        addSubview(keepSwipingButton)
        
        let imageWidth: CGFloat = 140
        
        descriptionLabel.anchor(top: nil, leading: leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))
        
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: imageWidth, height: imageWidth))
        currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        currentUserImageView.layer.cornerRadius = imageWidth / 2
        
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: imageWidth, height: imageWidth))
        cardUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cardUserImageView.layer.cornerRadius = imageWidth / 2
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 50))
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: sendMessageButton.leadingAnchor, bottom: nil, trailing: sendMessageButton.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 60))
    }
    

    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate func setupBlurView(){
        
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
        }) { (_) in
            
        }
    }
    
    @objc fileprivate func handleTapDismiss(){
        self.removeFromSuperview()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
