//
//  MessagesController.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/04.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import UIKit

class MessagesController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
    //下に相手のuidも入ってる！
    var user: User!{
        didSet{
            navigationItem.title = user.fullName
        }
    }
    
    let messageContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("送信", for: .normal)
        return button
    }()
    
    lazy var messageTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = true
        tv.text = "メッセージを入れてください。"
        tv.textColor = .lightGray
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.returnKeyType = .done
        tv.delegate = self
        return tv
    }()
    
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.03943666071, green: 0.02234290913, blue: 0.07596556097, alpha: 0.0886627907)
        return view
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "メッセージを入れてください。"{
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "メッセージを入れてください。"
            textView.textColor = .lightGray
        }
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
        
        messageContainerView.addSubview(messageTextView)
        messageTextView.anchor(top: nil, leading: messageContainerView.leadingAnchor, bottom: nil, trailing: sendButton.leadingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 40))
        messageTextView.centerYAnchor.constraint(equalTo: messageContainerView.centerYAnchor).isActive = true
        
        messageContainerView.addSubview(separatorLineView)
        separatorLineView.anchor(top: messageContainerView.topAnchor, leading: messageContainerView.leadingAnchor, bottom: nil, trailing: messageContainerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 1))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        setupNotificationObservers()
    }
    
    @objc fileprivate func handleTapDismiss(){
        self.view.endEditing(true)
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        NotificationCenter.default.removeObserver(self) // you'll have a retain cycle
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
//        print(keyboardFrame)
//
//        let bottomSpace = view.frame.height - messageContainerView.frame.origin.y - messageContainerView.frame.height
//        print(bottomSpace)
//
//        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
    }
    
    
    
}
