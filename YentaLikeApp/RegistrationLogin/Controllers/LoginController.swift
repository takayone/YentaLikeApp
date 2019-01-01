//
//  LoginController.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/29.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
   
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.backgroundColor = .white
        tf.placeholder = "Enter your email"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        tf.placeholder = "Enter your password"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    @objc fileprivate func handleTextChange(){
        
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
    }
    
    fileprivate func setupLayout() {
        
        let overallStackViews = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        navigationController?.isNavigationBarHidden = true
        view.addSubview(overallStackViews)
//        self.selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        overallStackViews.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackViews.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        overallStackViews.axis = .vertical
        overallStackViews.spacing = 8
        
        view.addSubview(goBackButton)
        goBackButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 0))
    }
    
}
