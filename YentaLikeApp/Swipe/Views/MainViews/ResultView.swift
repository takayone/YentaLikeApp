//
//  ResultView.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/03.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import UIKit

class ResultView: UIView {
    
    //多分Yentaではこの数はiPhoneのローカルに保存させているかもしれない。userDefaultsか何かか。それか普通にデータベースから呼び出してる？？データベースから呼び出すのが良いかもしれないけどめんどいから下のままにする
    var likeNumber: Int!{
        didSet{
            let attributedText = NSMutableAttributedString(string: "\(likeNumber ?? 0)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 32), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4470588235, green: 0.6941176471, blue: 0.5176470588, alpha: 1)])
            attributedText.append(NSAttributedString(string: "人", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]))
            likeNumberLabel.attributedText = attributedText
        }
    }
    var disLikeNumber: Int!{
        didSet{
            let attributedText = NSMutableAttributedString(string: "\(disLikeNumber ?? 0)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 32), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.3034319758, blue: 0.2616073392, alpha: 1)])
            attributedText.append(NSAttributedString(string: "人", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]))
            disLikeNumberLabel.attributedText = attributedText
        }
    }
    
    var totalNumbers: Int!{
        didSet{
            confirmationLabel.text = "今回のレコメンド\(totalNumbers ?? 10)人を\n全て確認しました"
        }
    }
    
    let confirmationLabel: UILabel = {
        let label = UILabel()
        label.text = "今回のレコメンド10人を\n全て確認しました"
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2048562765, green: 0.1738471687, blue: 0.04878479987, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        return label
    }()
    
    let disLikeNumberLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.9298198819, green: 0.9006029963, blue: 0.9708290696, alpha: 0.5)
        label.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: "0", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 32), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.3034319758, blue: 0.2616073392, alpha: 1)])
        attributedText.append(NSAttributedString(string: "人", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    let disLikeLabel: UILabel = {
        let label = UILabel()
        label.text = "× 興味なし"
        label.backgroundColor = #colorLiteral(red: 0.9298198819, green: 0.9006029963, blue: 0.9708290696, alpha: 0.5)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let likeNumberLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.9298198819, green: 0.9006029963, blue: 0.9708290696, alpha: 0.5)
        let attributedText = NSMutableAttributedString(string: "0", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 32), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4470588235, green: 0.6941176471, blue: 0.5176470588, alpha: 1)])
        attributedText.append(NSAttributedString(string: "人", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "○ 興味あり"
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = #colorLiteral(red: 0.9298198819, green: 0.9006029963, blue: 0.9708290696, alpha: 0.5)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .ultraLight)
        label.numberOfLines = 0
        label.text = "※マッチングの結果は20時に発表されます\n※本日出てきたお相手と本日マッチングするとは限りません"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(confirmationLabel)
        confirmationLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 100))
        
        let disLikeStackView = UIStackView(arrangedSubviews: [disLikeNumberLabel, disLikeLabel])
        disLikeStackView.axis = .vertical
        disLikeNumberLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        disLikeStackView.spacing = 1
        
        let likeStackView = UIStackView(arrangedSubviews: [likeNumberLabel, likeLabel])
        likeStackView.axis = .vertical
        likeNumberLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        likeStackView.spacing = 1
        
        let likeDisLikeStackViews = UIStackView(arrangedSubviews: [disLikeStackView, likeStackView])
        likeDisLikeStackViews.axis = .horizontal
        likeDisLikeStackViews.spacing = 10
        likeDisLikeStackViews.distribution = .fillEqually
        
        addSubview(likeDisLikeStackViews)
        likeDisLikeStackViews.anchor(top: confirmationLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 100))
        
        addSubview(infoLabel)
        infoLabel.anchor(top: likeDisLikeStackViews.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 100))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
