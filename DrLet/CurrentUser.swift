//
//  CurrentUser.swift
//  DrLet
//
//  Created by Venkat Madira on 10/03/2020.
//  Copyright © 2020 Venkat Madira. All rights reserved.
//

import Foundation
import Foundation

struct CurrentUser {
    let uid: String
    let firsrname: String
    let lastname: String
    let phonenumber: String
    let email: String
    let postcode: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.firsrname = dictionary["FirstName"] as? String ?? ""
        self.lastname = dictionary["LastName"] as? String ?? ""
        self.phonenumber = dictionary["PhoneNum"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.postcode = dictionary["Location"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
