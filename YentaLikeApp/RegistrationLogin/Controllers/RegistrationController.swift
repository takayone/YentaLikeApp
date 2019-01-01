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

class RegistrationController: UITableViewController, DatePickerCellDelegate {
    
    var user = User(fullName: "", imageUrl: "", age: 18, companyName: "", profession: "", startingDate: "", selfIntroduction: "", schoolName: "", schoolDepartment: "", uid: "", birthDate: "")
    
    lazy var headerView : UIView = {
        let view = UIView()
        view.addSubview(selectPhotoButton)
        selectPhotoButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16), size: .init(width: 0, height: 0))
        return view
    }()
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("写真を選択", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
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
    
    let footerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登録する", for: .normal)
        button.backgroundColor = .lightGray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    //1/1日次はここから。firebaseAuth.authで登録しつつ、storageに保管しつつ、全てのデータをデータベースに登録する
    @objc fileprivate func handleRegister(){
        print("toucing button tottoot")
        
//        Auth.auth().createUser(withEmail: <#T##String#>, password: <#T##String#>, completion: <#T##AuthDataResultCallback?##AuthDataResultCallback?##(AuthDataResult?, Error?) -> Void#>)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "登録画面"
        setupNotificationObservers()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
   
    }
    
    @objc fileprivate func handleTap(){
        view.endEditing(true)
    }
    
    fileprivate func setupNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func handleKeyboardWillShow(notification: Notification){
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = value.cgRectValue
        let bottomSpace: CGFloat = 250
//        let bottomSpace = view.frame.height - tableView.tableFooterView!.frame.origin.y - tableView.tableFooterView!.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    @objc fileprivate func handleKeyboardHide(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    class HeaderLabel: UILabel{
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
            font = UIFont.boldSystemFont(ofSize: 12)
        }
    }
    

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
          return headerView
        }
        let headerLabel = HeaderLabel()
        headerLabel.backgroundColor = .lightGray
        
        switch section {
        case 1:
            headerLabel.text = "名前"
        case 2:
            headerLabel.text = "生年月日"
        case 3:
            headerLabel.text = "会社名"
        case 4:
            headerLabel.text = "現職入社時期"
        case 5:
            headerLabel.text = "職種名"
        case 6:
            headerLabel.text = "学校名"
        case 7:
            headerLabel.text = "学部"
        default:
            headerLabel.text = "自己紹介文"
        }
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? view.frame.width : 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
 

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultCell = DefaultCell(style: .default, reuseIdentifier: "defaultCell")
        let datePickerCell = DatePickerCell(style: .default, reuseIdentifier: "datePickerCell")
        let selfIntroCell = SelfIntroCell(style: .default, reuseIdentifier: "selfIntroCell")
        
        
        switch indexPath.section {
        case 1:
            defaultCell.textField.text = user.fullName
            defaultCell.textField.addTarget(self, action: #selector(handleFullNameChanged), for: .editingChanged)
        case 2:
            datePickerCell.delegate = self
            datePickerCell.textField.text = user.birthDate
            return datePickerCell
        case 3:
            defaultCell.textField.placeholder = "会社名を入力してください"
            defaultCell.textField.text = user.companyName
            defaultCell.textField.addTarget(self, action: #selector(handleCompanyNameChanged), for: .editingChanged)
        case 4:
            datePickerCell.delegate = self
            datePickerCell.textField.text = user.startingDate
            return datePickerCell
        case 5:
            defaultCell.textField.placeholder = "職種名を入力してください"
            defaultCell.textField.text = user.profession
            defaultCell.textField.addTarget(self, action: #selector(hanldeProfessionChanged), for: .editingChanged)
        case 6:
            defaultCell.textField.placeholder = "学校名を入力してください"
            defaultCell.textField.text = user.schoolName
            defaultCell.textField.addTarget(self, action: #selector(handleSchoolNameChanged), for: .editingChanged)
        case 7:
            defaultCell.textField.placeholder = "学部名を入力してください"
            defaultCell.textField.text = user.schoolDepartment
            defaultCell.textField.addTarget(self, action: #selector(handleSchoolDepartmentChanged), for: .editingChanged)
        default:
            return selfIntroCell
        }
        
        return defaultCell
    }
    

    
    @objc fileprivate func handleFullNameChanged(textField: UITextField){
        user.fullName = textField.text ?? ""
        
    }
    
    @objc fileprivate func handleCompanyNameChanged(textField: UITextField){
        user.companyName = textField.text ?? ""
      
    }
    
    @objc fileprivate func hanldeProfessionChanged(textField: UITextField){
        user.profession = textField.text ?? ""
       
    }
    
    @objc fileprivate func handleSchoolNameChanged(textField: UITextField){
        user.schoolName = textField.text ?? ""
       
    }
    
    @objc fileprivate func handleSchoolDepartmentChanged(textField: UITextField){
        user.schoolDepartment = textField.text ?? ""
 
    }
    
    //上記と同じようにやろうとすると、初期入力時にnilとなってしまうからdelegateメソッドでtextFieldに入力してから、値を渡すこととした
    func didSetDate(dateString: String) {
        //aの時はこっち、bの時はこっちとしたいんだけども何がそれを分けられるのだろうか。
        
        user.startingDate = dateString
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    //Footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerButton
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 8 {
            return 50
        }
        
        return 0
    }
    
}
