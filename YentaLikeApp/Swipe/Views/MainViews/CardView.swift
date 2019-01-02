//
//  CardView.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/29.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didFinishSwiping(translationDirection: Int, user: User)
    func didTappingCardView(user: User)
    func changingGestureTranslationX(translationX: CGFloat)
    func whenShouldNotDismiss()
}

class CardView: UIView {
    
    var nextCardView: CardView?
    
    var user: User!{
        didSet{
            
            infoLabel.attributedText = user.sendUserInfo()
            
            if let imageUrl = user.imageUrl as? String, let url = URL(string: imageUrl){
                imageView.sd_setImage(with: url)
            }
            
            selfIntroLabel.attributedText = user.sendIntroInfo()
            
            
        }
    }
    
    var delegate: CardViewDelegate?
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "profile_selected"))
        iv.backgroundColor = .white
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
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        return view
    }()
    
    //labelを左上にするには？？
    let selfIntroLabel: UILabel = {
        let label = UILabel()
        label.text = "こんにちは今日もお元気でしょうか？？？\n\n別に元気がない感じならば元気を出して行きましょうまじで。\n\nホームページはいかになります。\nよろしくお願いします。\nhttps://www.google.com/"
        label.numberOfLines = 0
        return label
    }()
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    fileprivate func setupLayout() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        layer.cornerRadius = 10
        layoutSubviews()
        addSubview(imageView)
        addSubview(infoLabel)
        addSubview(separatorView)
        addSubview(selfIntroLabel)
        
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        
        infoLabel.anchor(top: topAnchor, leading: imageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 0, height: 80))
        
        separatorView.anchor(top: infoLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 1))
    
        selfIntroLabel.anchor(top: separatorView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 8))
        
    }
    
    //swipeしたあとその後でusersDetailを開くと、前のユーザーのままになる。もう一度押すと治る
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer){
        delegate?.didTappingCardView(user: user)
        print(user.fullName)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer){
   
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChange(gesture: gesture)
        case .ended:
            handleEnded(gesture: gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChange(gesture: UIPanGestureRecognizer){
        //cardView本体
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationTransform.translatedBy(x: translation.x, y: translation.y)
        self.delegate?.changingGestureTranslationX(translationX: translation.x)
    }
    
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        
        let translationDirection = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismiss = abs(gesture.translation(in: nil).x) > 80
        
        if shouldDismiss {

            //どっちのtranslationDirectionにするかをインプットとして入れる（likeの場合は1(右へ）, disLikeの場合は-1(左へ）
            self.delegate?.didFinishSwiping(translationDirection: translationDirection, user: user)
            
        } else {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.transform = .identity
                //SwipeControllerのlikeViewを.identityにしたいいい
                self.delegate?.whenShouldNotDismiss()
            })
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
