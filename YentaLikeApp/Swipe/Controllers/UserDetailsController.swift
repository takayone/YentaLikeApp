//
//  UserDetailsController.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/30.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit

protocol UserDetailsControllerDelegate {
    func didTapDislike(user: User)
    func didTapLike(user: User)
}

class UserDetailsController: UITableViewController {
    
    var user: User?
    
    var delegate: UserDetailsControllerDelegate?
    
    lazy var bottomStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [disLikeButton, likeButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 0.5
        return sv
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("興味あり", for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    let disLikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("興味なし", for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleLike(){
//        navigationController?.popViewController(animated: true)
        self.delegate?.didTapLike(user: user!)
    }
    
    @objc fileprivate func handleDislike(){
        //一旦SwipeControllerに戻る
//        navigationController?.popViewController(animated: true)
        self.delegate?.didTapDislike(user: user!)
    }
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    let headerView: HeaderView = {
        let headerView = HeaderView()
        return headerView
    }()
    
    class HeaderLabel: UILabel{
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
            font = UIFont.boldSystemFont(ofSize: 12)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            headerView.user = user
            return headerView
        }
        
        let headerLabel = HeaderLabel()
        headerLabel.backgroundColor = .lightGray

        
        switch section {
        case 1:
            headerLabel.text = "自己紹介"
            return headerLabel
        case 2:
            headerLabel.text = "職歴"
            return headerLabel
        case 3:
            headerLabel.text = "学歴"
            return headerLabel
        default:
            headerLabel.text = "職種タイプ"
            return headerLabel
        }
        

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 120
        }
        return 20
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textLabel?.attributedText = user?.sendIntroInfo()
            cell.textLabel?.numberOfLines = 0
            return cell
        case 2:
            cell.textLabel?.attributedText = user?.sendProfessionInfo()
            cell.textLabel?.numberOfLines = 0
            return cell
        case 3:
            cell.textLabel?.attributedText = user?.sendSchoolInfo()
            cell.textLabel?.numberOfLines = 0
            return cell
        default:
            cell.textLabel?.text = user?.profession
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .ultraLight)
            return cell
        }
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        return bottomStackView
    }
    
   

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4{
            return 100
        }
       return 0
    }

    
}
