//
//  RegistrationController.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/29.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase


class SettingsController: UITableViewController, DatePickerCellDelegate, BirthdayCellDelegate {
  
    
    var user = User(fullName: "", imageUrl: "", age: 18, companyName: "", profession: "", startingDate: "", selfIntroduction: "", schoolName: "", schoolDepartment: "", uid: "", birthDate: Date())
    
    let headerView : CustomHeaderView = {
        let view = CustomHeaderView()
        return view
    }()
    
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
    
//        navigationItem.title = "Settings"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
//        navigationItem.rightBarButtonItems = [
//            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout)),
//            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
//        ]
        setupNavigationItems()
        
        setupNotificationObservers()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
   
    }
    
    fileprivate func setupNavigationItems(){
        navigationItem.title = "詳細情報登録画面"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09851664624, green: 0.2761102814, blue: 0.5600723167, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)], for: .normal)
    }
    
    @objc fileprivate func handleSave(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let selfIntroduction = selfIntroCell.textView.text ?? ""
        let dictionary: [String: Any] = [
            "companyName": user.companyName,
            "profession": user.profession,
            "startingDate": user.startingDate,
            "schoolName": user.schoolName,
            "schoolDepartment": user.schoolDepartment,
            "birthDate": user.birthDate,
            "selfIntroduction": selfIntroduction
        ]
        
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.updateData(dictionary) { (err) in
            if let err = err{
                print("failed to update Firebase")
                return
            }
            
            print("success!!!!")
            let swipeController = SwipeController()
            let navController = UINavigationController(rootViewController: swipeController)
            self.present(navController, animated: true)
        }
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
        headerLabel.backgroundColor = #colorLiteral(red: 0.09851664624, green: 0.2761102814, blue: 0.5600723167, alpha: 1)
        headerLabel.textColor = .white
        
        switch section {
        case 1:
            headerLabel.text = "生年月日"
        case 2:
            headerLabel.text = "会社名"
        case 3:
            headerLabel.text = "現職入社時期"
        case 4:
            headerLabel.text = "職種名"
        case 5:
            headerLabel.text = "学校名"
        case 6:
            headerLabel.text = "学部"
        default:
            headerLabel.text = "自己紹介文"
        }
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 120 : 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
 
    let selfIntroCell = SelfIntroCell(style: .default, reuseIdentifier: "selfIntroCell")

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultCell = DefaultCell(style: .default, reuseIdentifier: "defaultCell")
        let birthdayCell = BirthdayCell(style: .default, reuseIdentifier: "birthdayCell")
        let datePickerCell = DatePickerCell(style: .default, reuseIdentifier: "datePickerCell")
       
        
        
        switch indexPath.section {
        case 1:
            birthdayCell.delegate = self
            birthdayCell.textField.text = user.changeBirthDateToString()
            return birthdayCell
        case 2:
            defaultCell.textField.placeholder = "会社名を入力してください"
            defaultCell.textField.text = user.companyName
            defaultCell.textField.addTarget(self, action: #selector(handleCompanyNameChanged), for: .editingChanged)
        case 3:
            datePickerCell.delegate = self
            datePickerCell.textField.text = user.startingDate
            return datePickerCell
        case 4:
            defaultCell.textField.placeholder = "職種名を入力してください"
            defaultCell.textField.text = user.profession
            defaultCell.textField.addTarget(self, action: #selector(hanldeProfessionChanged), for: .editingChanged)
        case 5:
            defaultCell.textField.placeholder = "学校名を入力してください"
            defaultCell.textField.text = user.schoolName
            defaultCell.textField.addTarget(self, action: #selector(handleSchoolNameChanged), for: .editingChanged)
        case 6:
            defaultCell.textField.placeholder = "学部名を入力してください"
            defaultCell.textField.text = user.schoolDepartment
            defaultCell.textField.addTarget(self, action: #selector(handleSchoolDepartmentChanged), for: .editingChanged)
        default:
            selfIntroCell.textView.text = user.selfIntroduction
            return selfIntroCell
        }
        
        return defaultCell
    }
    
    
    func didSetBirthday(birthDate: Date) {
        user.birthDate = birthDate
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
        user.startingDate = dateString
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
}
