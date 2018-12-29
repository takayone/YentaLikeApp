//
//  RegistrationController.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/29.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

class RegistrationController: UIViewController {
    

    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handlePhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    @objc fileprivate func handlePhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    

    
    let nameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.backgroundColor = .white
        tf.placeholder = "Enter your name"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
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
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.layer.cornerRadius = 22
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleRegister(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err{
                print("failed to create user:", err)
                return
            }
            
            print("successfully created user")
            self.savePhotoToStorage()
            //what should I do?? just save them to Firestore
           
        }
    }
    
    fileprivate func savePhotoToStorage(){
        
        guard let uploadData = selectPhotoButton.imageView?.image?.jpegData(compressionQuality: 0.5) else {return}
        let filePath = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "images\(filePath)")
        ref.putData(uploadData, metadata: nil) { (data, err) in
            if let err = err {
                print("failed to upload data to storage", err)
                return
            }
            
            ref.downloadURL(completion: { (url, err) in
                if let err = err{
                    print("failed to download url", err)
                    return
                }
                guard let urlString = url?.absoluteString else {return}
                
                self.saveInfoToFirestore(url: urlString)
            })
            
        }
    }
    
    fileprivate func saveInfoToFirestore(url: String){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        
        
        let documentData: [String : Any] = ["fullName": nameTextField.text ?? "", "age": 18, "email": emailTextField.text ?? "", "imageUrl": url]
        
        Firestore.firestore().collection("users").document(uid).setData(documentData) { (err) in
            if let err = err{
                print("failed to setData", err)
                return
            }
            
            print("successfully save info to Firestore")
            
        }

        
    }
    
    
    
    let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go To Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleGoToLogin(){
        print("go to login.....")
        let loginController = LoginController()
        present(loginController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .blue
        let overallStackViews = UIStackView(arrangedSubviews: [selectPhotoButton, nameTextField, emailTextField, passwordTextField, registerButton])
        navigationController?.isNavigationBarHidden = true
        view.addSubview(overallStackViews)
        self.selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        overallStackViews.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackViews.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        overallStackViews.axis = .vertical
        overallStackViews.spacing = 8
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 0))
    }
    
    
}
