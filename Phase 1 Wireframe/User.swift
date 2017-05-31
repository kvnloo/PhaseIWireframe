//
//  User.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/31/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit

class User: NSObject {
    /// The username for a given user.
    var uid: String?
    /// The password for a given user.
    var pw: String?
    /// The token if using AUTH.
    var token: String?
    /// The data to be stored in the server.
    var data: [Float]?
    /// Determines if the user signed in with an email or a phone number
    var email: Bool?
    
    init(uid: String?, pw: String, email: Bool?) {
        self.uid   = uid
        self.pw    = pw
        self.email = email
    }
    
    init(token: String?) {
        self.token = token
    }
    
    func setData(data: [Float]?) {
        self.data  = data
    }

}
