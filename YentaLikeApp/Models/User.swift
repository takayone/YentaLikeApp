//
//  User.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2018/12/29.
//  Copyright © 2018 takahitoyoneda. All rights reserved.
//

import Foundation

class User {
    let fullName: String
    let imageUrl: String
    let age: Int
    let profession: String
    let selfIntroduction: String
    
    init(fullName: String,imageUrl: String, age: Int, profession: String, selfIntroduction: String ){
        self.fullName = fullName
        self.imageUrl = imageUrl
        self.age = age
        self.profession = profession
        self.selfIntroduction = selfIntroduction
    }
}
