//
//  User.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/29.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import UIKit

class User {
    var fullName: String
    var imageUrl: String
    var age: Int
    var companyName: String
    var profession: String
    var startingDate: String
    var selfIntroduction: String
    var schoolName: String
    var schoolDepartment: String
    var uid: String
    var birthDate: Date
    
    init(dictionary: [String: Any]) {
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 18
        self.companyName = dictionary["companyName"] as? String ?? ""
        self.profession = dictionary["profession"] as? String ?? ""
        self.selfIntroduction = dictionary["selfIntroduction"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.schoolName = dictionary["schoolName"] as? String ?? ""
        self.schoolDepartment = dictionary["schoolDepartment"] as? String ?? ""
        self.startingDate = dictionary["startingDate"] as? String ?? ""
        self.birthDate = dictionary["birthDate"] as? Date ?? Date()
    }
    
    init(fullName: String, imageUrl: String, age: Int, companyName: String, profession: String, startingDate: String, selfIntroduction: String, schoolName: String, schoolDepartment: String, uid: String, birthDate: Date) {
        self.fullName = fullName
        self.imageUrl = imageUrl
        self.age = age
        self.companyName = companyName
        self.profession = profession
        self.startingDate = startingDate
        self.selfIntroduction = selfIntroduction
        self.schoolName = schoolName
        self.schoolDepartment = schoolDepartment
        self.uid = uid
        self.birthDate = birthDate
    }
    

    func sendUserInfo() -> NSMutableAttributedString{
        
        let attributedText = NSMutableAttributedString(string: fullName ?? "", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .heavy)])
        
        attributedText.append(NSAttributedString(string: "(" + "\(age)" + ")", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .light)]))
        
        attributedText.append(NSAttributedString(string: "\n\(companyName)", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .ultraLight)]))
        
        attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .ultraLight)]))
        //行間
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        
        
        return attributedText
    }
    //attributedTextで文字の間を変更するにはどうすれば良いか？？
    
    func sendIntroInfo() -> NSMutableAttributedString{
        
        let attributedText = NSMutableAttributedString(string: selfIntroduction ?? "", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .ultraLight)])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        
        return attributedText
    }
  
    func sendProfessionInfo() -> NSMutableAttributedString{
        
        let attributedText = NSMutableAttributedString(string: companyName ?? "", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .heavy)])
        
        attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .ultraLight)]))
        
         attributedText.append(NSAttributedString(string: "\n2017年10月〜現職", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .ultraLight)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
  
        return attributedText
    }
    
    func sendSchoolInfo() -> NSMutableAttributedString{
        
        let attributedText = NSMutableAttributedString(string: schoolName ?? "", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .heavy)])
        
        attributedText.append(NSAttributedString(string: "\n\(schoolDepartment)", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .ultraLight)]))
        
        attributedText.append(NSAttributedString(string: "\n2015年4月〜2018年3月", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .ultraLight)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        
        return attributedText
    }
    
    func changeBirthDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "ja")
        let dateString = dateFormatter.string(from: self.birthDate)
        return dateString
    }
    
    
}

