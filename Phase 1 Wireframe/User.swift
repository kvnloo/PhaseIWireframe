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
    
    /// Initializer for the user object with a username, password, and a Boolean describing if using an email or phonenumber.
    init(uid: String?, pw: String, email: Bool?) {
        self.uid   = uid
        self.pw    = pw
        self.email = email
    }
    
    /// Initializes user with an API token that can be attained through social media login.
    init(token: String?) {
        self.token = token
    }
    
    /// A function that sets the data object of the user.
    func setData(data: [Float]?) {
        self.data  = data
    }

}
