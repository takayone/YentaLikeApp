//
//  CardView.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/29.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit

class CardView: UIView {
    
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
    
    let tintBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
        addSubview(imageView)
        addSubview(infoLabel)
        addSubview(tintBar)
        
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        
        infoLabel.anchor(top: topAnchor, leading: imageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        
        tintBar.anchor(top: infoLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 4))
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer){
   
        switch gesture.state {
        case .changed:
            handleChange(gesture: gesture)
        case .ended:
            handleEnded(gesture: gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChange(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        
        let translationDirection = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismiss = abs(gesture.translation(in: nil).x) > 80
        
        if shouldDismiss {
            self.transform = CGAffineTransform(translationX: CGFloat(500 * translationDirection), y: 0)
            self.removeFromSuperview()
        } else {
            self.transform = .identity
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
