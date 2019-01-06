//
//  SwipeController.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/29.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

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
    
    let likeView: CustomLikeDislikeView = {
        let view = CustomLikeDislikeView()
        view.backgroundColor = #colorLiteral(red: 0.4470588235, green: 0.6941176471, blue: 0.5176470588, alpha: 1)
        view.layer.cornerRadius = 4
        return view
    }()
    
    let disLikeView: CustomLikeDislikeView = {
        let view = CustomLikeDislikeView()
        view.backgroundColor = #colorLiteral(red: 0.9193864465, green: 0.296697557, blue: 0.2393967509, alpha: 1)
        view.layer.cornerRadius = 4
        let attrbutedText = NSMutableAttributedString(string: "×", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30, weight: .bold)])
        attrbutedText.append(NSAttributedString(string: "\n興味なし", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        view.textLabel.attributedText = attrbutedText
        return view
    }()
    
    let resultView: ResultView = {
        let view = ResultView()
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupStatusBars()
        setupLayout()
        fetchCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    //現ユーザーを入れ込む
    var user: User?
    let fetchHud = JGProgressHUD()
    
    fileprivate func fetchCurrentUser(){
        fetchHud.show(in: view)
        fetchHud.textLabel.text = "あなたにオススメの\nユーザーを探しています"
        
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.getDocument { (snapshot, err) in
            
            if let err = err {
                print("failed to fetch current user",err)
                self.fetchHud.dismiss()
                self.showHudWithError(err: err)
                return
            }
            
            guard let dictionary: [String: Any] = snapshot?.data() else {return}
            self.user = User(dictionary: dictionary)
            self.fetchSwipes()
        }
    }
    
    
    //全ユーザーをfetchする。
    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes(){
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        //swipesのデータをとる
        let ref = Firestore.firestore().collection("swipes").document(currentUserUid)
        ref.getDocument { (snapshot, err) in
            if let err = err{
                print("failed to fetch current user swipe info",err)
                self.fetchHud.dismiss()
                self.showHudWithError(err: err)
                return
            }
            
            print("successfully get current user swipe info")
            
            //元々はguard letでdataを宣言していたが、初期に作る時にreturn
            let data = snapshot?.data() as? [String: Int] ?? ["": 0]
            //いかによりswipesに[いろんなuserのuid: 1,0]が入った。
            self.swipes = data
            
            //全てのユーザーの呼び出し
            self.fetchUsersFromFireStore()
        }
    }
    
    
    
    fileprivate func fetchUsersFromFireStore(){
        
        let ref = Firestore.firestore().collection("users")
        ref.getDocuments { (allDocuments, err) in
            if let err = err{
                print("failed to fetch users:", err)
                self.fetchHud.dismiss()
                self.showHudWithError(err: err)
                return
            }
            
            guard let snapshots = allDocuments?.documents else {return}
            guard let currentUserUid = Auth.auth().currentUser?.uid else {return}

            //usersに全てのユーザーを入れる
            snapshots.forEach({ (snapshot) in
                guard let dictionary = snapshot.data() as? [String : Any] else {return}
                let user = User(dictionary: dictionary)
                let cardUID = user.uid
                
                //今ログインしているユーザーは出ないように弾くロジック
                let notCurrentUserAddedToSwipe = user.uid != currentUserUid
                //過去swipeしたユーザである時（swipes[String: Any]のvalue値に何か値がない場合には発動
                let hasNotSwipedBefore = self.swipes[cardUID] == nil
//                let hasNotSwipedBefore = true
                
                if notCurrentUserAddedToSwipe && hasNotSwipedBefore{
                    self.users.append(user)
                }
            })
            
            self.setupCardView()
        }
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
        
        //結果のresultViewを一番後ろに配置
        cardDeckView.addSubview(resultView)
        cardDeckView.sendSubviewToBack(resultView)
        resultView.fillSuperview()
        fetchHud.dismiss()
    }

    

    
    //つまりここのユーザーが更新されていないことによって、前のユーザーが出てきてしまっている
    func didTappingCardView(user: User) {
        let userDetailsController = UserDetailsController()
        
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
    var likeNumber: Int = 0
    var disLikeNumber: Int = 0
  
    func didFinishSwiping(translationDirection: Int, user: User) {
        
        //likeViewをいなくならせる
        likeView.transform = .identity
        disLikeView.transform = .identity
        statusBars.subviews[indexNumber].backgroundColor = #colorLiteral(red: 0.2352941176, green: 0.3803921569, blue: 0.6117647059, alpha: 1)
        
        //resultViewに表示させるようのlikeNumber/disLikeNumberを渡す
        if translationDirection == 1 {
            likeNumber = likeNumber + 1
            resultView.likeNumber = likeNumber
        } else {
            disLikeNumber = disLikeNumber + 1
            resultView.disLikeNumber = disLikeNumber
        }
        //resultViewのlikeDislikeの合計を表示させる
        let totalNumbers = likeNumber + disLikeNumber
        resultView.totalNumbers = totalNumbers
        
        performSwipeAnimation(translation: CGFloat(700 * translationDirection), angle: CGFloat(15 * translationDirection)) {
            self.indexNumber = min(self.indexNumber+1, 9)
            //likeにswipeされた場合にswipesで保存
            self.saveSwipesToFirestore(user: user, translationDirection: translationDirection)
        }
    }
    
    fileprivate func saveSwipesToFirestore(user: User, translationDirection: Int){
        var didLike: Int = 0
        
        if translationDirection == 1 {
            didLike = 1
        }
        //とりあえずちゃんとregistrationページを作ってから取り掛かる。そうしないとこのAuth.auth().currentUserがそもそもおらんことになる

        guard let uid = Auth.auth().currentUser?.uid else {return}
       
        guard let cardUID = user.uid as? String else {return}
        
        //Swipe相手のuid。オケだったら1を入れだめだったら-1とする(translationDirection)
        let documentData = [cardUID: didLike]
        
        //ここからやりたいことは・・・もしswipes.uidのgetDocument内でデータが存在する場合には、updateのFirestoreを使う
        //しそして存在しない場合には以下のような方法で保存を行う。保存できるところまでは確認完了。ここからRegistration, Loginの方の実装に向かう
        
        //今のユーザーのswipeのデータが存在する場合には、updateを呼び出し、しない場合にはsetDataを呼び出す
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err{
                print("failed to fetch current user swipes", err)
                return
            }
            print("successfully fetch current user's swipes")
            
            if snapshot?.exists == true {
                
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData, completion: { (err) in
                    if let err = err{
                        print("failed to update swipe data",err)
                        return
                    }
                    
                    print("successfully update swipe data")
                    //matchした時の処理を書く
                    self.checkUserIfMatchExists(cardUID: cardUID)
                })
                
                
            } else {
                
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (err) in
                    if let err = err{
                        print("failed to save data",err)
                        return
                    }
                    
                    print("successfully save swipes to firestore")
                    //matchした時の処理を書く
                    self.checkUserIfMatchExists(cardUID: cardUID)
                    
                }
                
            }
            
        }
    }
    
    fileprivate func checkUserIfMatchExists(cardUID: String){
        
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, err) in
            if let err = err{
                print("failed to fetch document for cardUser",err)
                return
            }
            
            guard let data = snapshot?.data() else {return}
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let hasMatched = data[uid] as? Int == 1
            
            if hasMatched {
                print("has matched!!")
//                self.presentMatchView(cardUID: cardUID)
                //matchingした時にどうするのか？
                //このマッチングしたという情報をどこかに保存したいところ。。
                //messages.uid.cardUid というものを用意して　今のユーザー⇨マッチしたユーザーのUID
                //そしてmessages側でfetch messages currentUserid
                self.presentMatchView(cardUID: cardUID)
                self.saveMatchingInfoToFirestore(cardUID: cardUID)
            }
        }
    }
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = self.user
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    fileprivate func saveMatchingInfoToFirestore(cardUID: String) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        
        let docData = [cardUID: 1]
        let ref = Firestore.firestore().collection("matches").document(currentUserUid)
        
        ref.getDocument { (snapshot, err) in
            if let err = err{
                print("failed to fetch matches",err)
                return
            }
            
            if snapshot?.exists == true{
                
                ref.updateData(docData, completion: { (err) in
                    if let err = err{
                        print("failed to update matching data", err)
                        return
                    }
                    
                    print("successfully update matching data")
                    
                })
                
            } else {
                ref.setData(docData) { (err) in
                    if let err = err{
                        print("failed to save matching data to firestore",err)
                        return
                    }
                    
                    print("successfully save matching data to firestore")
                }
                
            }
            
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
        let duration = 0.6
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
    
    //みぎやひだりからスライドインしてくるlikeViewの移動
    func changingGestureTranslationX(translationX: CGFloat) {
        
        let likeTranslationRange: CGFloat = min(translationX, CGFloat(likeView.frame.width))
        likeView.transform = CGAffineTransform(translationX: -likeTranslationRange, y: 0)
        
        let disLikeTranslationRange: CGFloat = min(-translationX, CGFloat(disLikeView.frame.width))
        disLikeView.transform = CGAffineTransform(translationX: disLikeTranslationRange, y: 0)
    }
    
    //dismissの必要がないときにlikeViewをもとのいちに戻す
    func whenShouldNotDismiss() {
        likeView.transform = .identity
        disLikeView.transform = .identity
    }
    

    
   
    //layout系
    fileprivate func setupStatusBars(){

        (0..<10).forEach { (_) in
            let view = UIView()
            view.layer.borderWidth = 1
            view.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            statusBars.addArrangedSubview(view)
        }
        
    }
    
    
    fileprivate func setupLayout(){
        
        navigationItem.title = "新しい人と出会う"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09851664624, green: 0.2761102814, blue: 0.5600723167, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ログアウト", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)], for: .normal)
        
        
        view.backgroundColor = .white
        view.addSubview(statusBars)
        view.addSubview(cardDeckView)
        statusBars.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 10) )
        cardDeckView.anchor(top: statusBars.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
        
        view.addSubview(likeView)
        //興味あるのView。最初は見えないところからスタートさせる。gestureの値を受け取るには？
        let width: CGFloat = 80
        likeView.anchor(top: nil, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: -width), size: .init(width: width, height: width))
        likeView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(disLikeView)
        disLikeView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: -width, bottom: 0, right: 0), size: .init(width: width, height: width))
        disLikeView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc fileprivate func handleLogout(){
        try? Auth.auth().signOut()
        let registrationControler = RegistrationController()
        let navController = UINavigationController(rootViewController: registrationControler)
        present(navController, animated: true)
    }
    
    fileprivate func showHudWithError(err: Error){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fail"
        hud.detailTextLabel.text = err.localizedDescription
        hud.show(in: view)
        hud.dismiss(afterDelay: 4.0)
    }
    

    
}
