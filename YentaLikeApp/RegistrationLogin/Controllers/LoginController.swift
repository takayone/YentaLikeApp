//
//  LoginController.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/29.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
   
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.backgroundColor = .white
        tf.placeholder = "メールアドレスを入力してください"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        tf.placeholder = "パスワードを入力してください"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        
        let isValidForm = emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
        
        if isValidForm{
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        }
        
    }
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.layer.cornerRadius = 22
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleLogin(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err{
                print("failed to sing in")
                return
            }
            
            let mainTabController = MainTabBarController()
            self.present(mainTabController, animated: true)
        }
    }
    
    let goBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登録画面へ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.addTarget(self, action: #selector(handleGoBack), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleGoBack(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setupGradientBackgroundcolor()
        setupLayout()
        setupNotificationObservers()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
   
    lazy var overallStackViews = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
    
    fileprivate func setupLayout() {
    
        navigationController?.isNavigationBarHidden = true
        view.addSubview(overallStackViews)
        overallStackViews.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackViews.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        overallStackViews.axis = .vertical
        overallStackViews.spacing = 8
        
        view.addSubview(goBackButton)
        goBackButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 0))
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
        print(keyboardFrame)
        
        let bottomSpace = view.frame.height - overallStackViews.frame.origin.y - overallStackViews.frame.height
        print(bottomSpace)
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    
}
