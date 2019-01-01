//
//  BirthdayCell.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/01.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import UIKit

protocol BirthdayCellDelegate {
    func didSetBirthday(birthDate: Date)
}

class BirthdayCell: UITableViewCell {
    
    var delegate: BirthdayCellDelegate?
    
    lazy var textField: CustomTextField = {
        let tf = CustomTextField(padding: 16, height: 40)
        tf.placeholder = "入社時期を記入してください"
        tf.inputView = datePicker
        tf.inputAccessoryView = createToolbar()
        return tf
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.locale = Locale(identifier: "ja")
        dp.date = Date()
        return dp
    }()
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 44)
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        space.width = 12
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        let toolbarItems = [flexSpaceItem, doneButtonItem, space]
        
        toolbar.setItems(toolbarItems, animated: true)
        
        return toolbar
    }
    
    
    @objc private func donePicker() {
        endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "ja")
        let birthDate = dateFormatter.string(from: datePicker.date)
        textField.text =  birthDate
        //Registration Controller側にdateの値を渡す
        self.delegate?.didSetBirthday(birthDate: datePicker.date)
    }
    
    
    //doneButtonをおす→textView.textに表示させる
    //cell.textFieldText.addTarget =>上の処理の前にきてしまってる
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
