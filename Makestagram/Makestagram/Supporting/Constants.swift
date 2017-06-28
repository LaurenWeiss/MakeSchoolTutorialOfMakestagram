//
//  Constants.swift
//  Makestagram
//
//  Created by Lauren Weiss on 6/27/17.
//  Copyright © 2017 Lauren Weiss. All rights reserved.
//

import Foundation

struct Constants {
    struct Segue {
        static let toCreateUsername = "toCreateUsername"
    }
    struct UserDefaults {
        //We're using the uid and username keys to store each respective 
        //property of the user object. We'll later use currentUser to store our current user.
        static let currentUser = "currentUser"
        static let uid = "uid"
        static let username = "username"
    }
    
}
