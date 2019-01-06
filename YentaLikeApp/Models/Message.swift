//
//  Message.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/04.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import Foundation
import Firebase

class Message {
    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
    }
    
    init(fromId: String, text: String, timestamp: NSNumber, toId: String) {
        self.fromId = fromId
        self.text = text
        self.timestamp = timestamp
        self.toId = toId
    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
