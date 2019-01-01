//
//  SwipeController.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/29.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase

class SwipeController: UIViewController,CardViewDelegate, UserDetailsControllerDelegate {

    
    var users = [User]()

    let statusBars: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    let cardDeckView: UIView = {
        let view = SwipeResultView()
        view.backgroundColor = .white
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupStatusBars()
        setupLayout()
//        setupCardView()
        fetchUsersFromFireStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func fetchUsersFromFireStore(){
        
        let ref = Firestore.firestore().collection("users")
        ref.getDocuments { (allDocuments, err) in
            if let err = err{
                print("failed to fetch users:", err)
                return
            }
            
            guard let snapshots = allDocuments?.documents else {return}
            
            //usersに全てのユーザーを入れる
            snapshots.forEach({ (snapshot) in
                guard let dictionary = snapshot.data() as? [String : Any] else {return}
                let user = User(dictionary: dictionary)
                self.users.append(user)
            })
            
            self.setupCardView()
        }
    }
    
    func didTappingCardView(user: User) {
        let userDetailsController = UserDetailsController()
        //いまい見ているユーザーを渡したい
        //User => User(uid:///)
        //CardViewのprotocolで回せばおけ
        userDetailsController.user = user
        userDetailsController.delegate = self
        let navController = UINavigationController(rootViewController: userDetailsController)
        navigationController?.pushViewController(userDetailsController, animated: true)
    }
    
    
    //Swiping・like系
    //したのロジックでswipeを完了したらば反応させる
    //swipeを一回ごとにいろstatusBar.subviewsの色を変えていく
    //statusbar.subviews[index]的な感じで行ける？
    var indexNumber: Int = 0
  
    func didFinishSwiping(translationDirection: Int, user: User) {
        
        statusBars.subviews[indexNumber].backgroundColor = .blue
        performSwipeAnimation(translation: CGFloat(700 * translationDirection), angle: CGFloat(15 * translationDirection)) {
            self.indexNumber = min(self.indexNumber+1, 9)
            
            //likeにswipeされた場合にswipesで保存
            self.saveSwipesToFirestore(user: user, translationDirection: translationDirection)
        }
    }
    
    fileprivate func saveSwipesToFirestore(user: User, translationDirection: Int){
        
        print("hey")
        //とりあえずちゃんとregistrationページを作ってから取り掛かる。そうしないとこのAuth.auth().currentUserがそもそもおらんことになる

        guard let uid = Auth.auth().currentUser?.uid else {return}
       
        guard let cardUID = user.uid as? String else {return}
        
        //Swipe相手のuid。オケだったら1を入れだめだったら-1とする(translationDirection)
        let documentData = [cardUID: translationDirection]
        
        //12/31 ここからやりたいことは・・・もしswipes.uidのgetDocument内でデータが存在する場合には、updateのFirestoreを使う
        //しそして存在しない場合には以下のような方法で保存を行う。保存できるところまでは確認完了。ここからRegistration, Loginの方の実装に向かう
        
        Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (err) in
            if let err = err{
                print("failed to save data",err)
                return
            }
            print("save to firestore")
            
        }
    }
    
  
    //usersDetailsControllerでlikeもしくはdislikeをした時の挙動
    func didTapLike(user: User) {
        
        self.navigationController?.popViewController(animated: true)
        
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.didFinishSwiping(translationDirection: 1, user: user)
        }) { (_) in
        }
        
    }
    
    func didTapDislike(user: User) {
        //ここでdisLikeのパフォームをさせたいけどどうするか？
        //statusBarの色付け
        self.navigationController?.popViewController(animated: true)
        
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.didFinishSwiping(translationDirection: -1, user: user)
        }) { (_) in
        }
    }
    
    
    func performSwipeAnimation (translation: CGFloat, angle: CGFloat, completion:@escaping ()->()) {
        let duration = 1.2
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        //ロジックめっちゃ複雑だけども、carDeckViewのsubviewとしてトップのviewが来て欲しい.
        //でもcardDeckViewにはsubview.のラストで今見えてるviewがあるそのため、.lastとしてだす
        let cardView = cardDeckView.subviews.last
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
            //したのcompletionブロックは、indexNumberをこの処理が終わった後にたすために入れてる
            completion()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
        
    }

    
   
    //layout系
    fileprivate func setupStatusBars(){

        (0..<10).forEach { (_) in
            let view = UIView()
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.lightGray.cgColor
            statusBars.addArrangedSubview(view)
        }
        
    }
    
    
    fileprivate func setupLayout(){
        
        navigationItem.title = "新しい人と出会う"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09851664624, green: 0.2761102814, blue: 0.5600723167, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ログアウト", style: .plain, target: self, action: #selector(handleLogout))
        
        view.backgroundColor = .white
        view.addSubview(statusBars)
        view.addSubview(cardDeckView)
        statusBars.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 10) )
        cardDeckView.anchor(top: statusBars.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    @objc fileprivate func handleLogout(){
        try? Auth.auth().signOut()
        let registrationControler = RegistrationController()
        let navController = UINavigationController(rootViewController: registrationControler)
        present(navController, animated: true)
    }
    
    fileprivate func setupCardView() {
        var index: Int = 0
        //最大10まで、最低users.countまで
        let cardFetchingNumbers = min(users.count ,10)
        
        (0..<cardFetchingNumbers).forEach { (_) in
            let cardView = CardView()
            cardView.delegate = self
            cardView.user = self.users[index]
            //ここにuidはある
            cardDeckView.addSubview(cardView)
            cardDeckView.sendSubviewToBack(cardView)
            cardView.fillSuperview()
            index = min(index + 1, 10)
        }
    }
    //swipes.currentuserid.
    
    
}
