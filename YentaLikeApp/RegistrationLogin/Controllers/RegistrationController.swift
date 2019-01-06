//
//  RegistrationController.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/01.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

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

class RegistrationController: UIViewController  {
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("写真を選択", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
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
        tf.placeholder = "名前を入れてください"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.backgroundColor = .white
        tf.placeholder = "メールアドレスを入れてください"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        tf.placeholder = "パスワードを入れてください"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    //３つが入力された時にregisterbuttonが押せるようにする。
    @objc fileprivate func handleTextChange(textField: UITextField) {
        
        let isValidForm = selectPhotoButton.imageView != nil && nameTextField.text?.isEmpty == false && emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
        
        if isValidForm{
            registerButton.isEnabled = true
            registerButton.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        }
        
    }
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("登録する", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.layer.cornerRadius = 22
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ログイン画面へ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleGoToLogin(){
        let loginController = LoginController()
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    
    let registeringHud = JGProgressHUD()
    
    @objc fileprivate func handleRegister(){
        self.handleTapDismiss()
        createUserInFirebase()
    }
    
    fileprivate func createUserInFirebase(){
        registeringHud.show(in: view)
        registeringHud.textLabel.text = "ユーザー登録中・・・"
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err{
                print("failed to create user", err)
                self.registeringHud.dismiss()
                self.showHudWithError(err: err)
                return
            }
            
            print("successfully created user")
            
            self.savetoFirestroreStorage()
        }
    }
    
  
 
    fileprivate func savetoFirestroreStorage(){
        let fileName = UUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "images/").child(fileName)
        
        guard let uploadData = selectPhotoButton.imageView?.image?.jpegData(compressionQuality: 0.5) else {return}
        
        ref.putData(uploadData, metadata: nil) { (data, err) in
            if let err = err{
                print("failed to put data to storage", err)
                self.registeringHud.dismiss()
                self.showHudWithError(err: err)
                return
            }
            
            print("successfully put img data to storage")
            
            ref.downloadURL(completion: { (url, err) in
                
                if let err = err{
                    print("failed to download url", err)
                    self.registeringHud.dismiss()
                    self.showHudWithError(err: err)
                    return
                }
                guard let urlString = url?.absoluteString else {return}
                print("successfully download url: \(urlString)")
                
                self.saveToFirestoreWithUrl(imageUrl: urlString)
            })
            
        }
    }
    
    //settingControllerに送る用
    var user = User(fullName: "", imageUrl: "", age: 18, companyName: "", profession: "", startingDate: "", selfIntroduction: "", schoolName: "", schoolDepartment: "", uid: "", birthDate: Date())
    
    fileprivate func saveToFirestoreWithUrl(imageUrl: String){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let fullName = nameTextField.text else {return}
        guard let email = emailTextField.text else {return}
        
        user.fullName = fullName
        user.imageUrl = imageUrl
        
        let docData: [String : Any] = ["fullName": fullName, "email": email, "uid": uid, "imageUrl": imageUrl]
        
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.setData(docData) { (err) in
            if let err = err{
                print("failed to save to Firestore",err)
                self.registeringHud.dismiss()
                self.showHudWithError(err: err)
                return
            }
            
            print("successfully save to firestore")
            let settingController = SettingsController()
            settingController.user = self.user
            let navController = UINavigationController(rootViewController: settingController)
            self.present(navController, animated: true)
        }
    }
    
    
    
    fileprivate func showHudWithError(err: Error){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fail"
        hud.detailTextLabel.text = err.localizedDescription
        hud.show(in: view)
        hud.dismiss(afterDelay: 4.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setupGradientBackgroundcolor()
        setupLayout()
        
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
        print(keyboardFrame)
     
        let bottomSpace = view.frame.height - overallStackViews.frame.origin.y - overallStackViews.frame.height
        print(bottomSpace)
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    

    lazy var verticalStackViews: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            nameTextField,
            emailTextField,
            passwordTextField,
            registerButton
            ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    
    lazy var overallStackViews = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        verticalStackViews
        ])
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.verticalSizeClass == .compact {
            overallStackViews.axis = .horizontal
        } else {
            overallStackViews.axis = .vertical
        }
    }
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(overallStackViews)
        selectPhotoButton.heightAnchor.constraint(equalToConstant: 250).isActive = true
        overallStackViews.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackViews.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        overallStackViews.axis = .horizontal
        overallStackViews.spacing = 8
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 0))
    }
    
}
