//
//  MessagesController.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/04.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
    //下に相手のuidも入ってる！
    var user: User!{
        didSet{
            navigationItem.title = user.fullName
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid as? String, let toId = user.uid as? String else {
            return
        }
        
        
        let messagesRef = Firestore.firestore().collection("messages").whereField("fromId", isEqualTo: uid).whereField("toId", isEqualTo: toId)
        messagesRef.addSnapshotListener { (snapshots, err) in
            if let err = err {
                print("failed to fetch messages", err)
                return
            }
            
            self.messages.removeAll()
            let documents =  snapshots?.documents
            documents?.forEach({ (document) in
                guard let dictionary: [String: Any] = document.data() else {return}
                let message = Message(dictionary: dictionary)
                self.messages.append(message)
                self.collectionView.reloadData()
            })
        }
        
    }
    
  
    
    
    let cellId = "cellId"
    
    let messageContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("送信", for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    lazy var messageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "メッセージを入れてください。"
        tf.font = UIFont.systemFont(ofSize: 16)
        return tf
    }()
    
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.03943666071, green: 0.02234290913, blue: 0.07596556097, alpha: 0.0886627907)
        return view
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tabBarController?.tabBar.isHidden = true
        collectionView.backgroundColor = .white
        view.backgroundColor = .white
        
        collectionView.addSubview(messageContainerView)
        messageContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
        
        messageContainerView.addSubview(sendButton)
        sendButton.anchor(top: nil, leading: nil, bottom: nil, trailing: messageContainerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8), size: .init(width: 40, height: 40))
        sendButton.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor).isActive = true
        
        messageContainerView.addSubview(messageTextField)
        messageTextField.anchor(top: nil, leading: messageContainerView.leadingAnchor, bottom: nil, trailing: sendButton.leadingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 40))
        messageTextField.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor).isActive = true
        
        messageContainerView.addSubview(separatorLineView)
        separatorLineView.anchor(top: messageContainerView.topAnchor, leading: messageContainerView.leadingAnchor, bottom: nil, trailing: messageContainerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 1))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        setupNotificationObservers()
        
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
    }
    
    
    @objc func handleSend() {
        
        let randomId = UUID().uuidString
        let ref = Firestore.firestore().collection("messages").document(randomId)
        
        let toId = user.uid ?? ""
        let fromId = Auth.auth().currentUser?.uid ?? ""
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = ["text": messageTextField.text ?? "", "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String: Any]

        ref.setData(values) { (err) in
            if let err = err{
                print("failed to send messages to firestore",err)
                return
            }
            self.messageTextField.text = nil
            print("successfully sending messages to firestore")

            
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.text!).width + 32
        
        return cell
    }
    
    //ここのロジックでどちらか振り分けてる！！
    fileprivate func setupCell(_ cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.imageUrl, let url = URL(string: profileImageUrl) {
            cell.profileImageView.sd_setImage(with: url)
        }
        
        ///ここが超大事！
        if message.fromId == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
        } else {
            //incoming gray
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 240/255, green: 240/255, blue: 240/255)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        //get estimated height somehow????
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text).height + 20
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16)]), context: nil)
    }
    
    
    
    
    
    @objc fileprivate func handleTapDismiss(){
        self.view.endEditing(true)
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        NotificationCenter.default.removeObserver(self) // you'll have a retain cycle
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.messageContainerView.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardWillShow(notification: Notification) {

        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        self.messageContainerView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
        
    }
    

}

fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}


fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}
