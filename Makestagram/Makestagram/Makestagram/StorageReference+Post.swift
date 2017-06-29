//
//  StorageReference+Post.swift
//  Makestagram
//
//  Created by Lauren Weiss on 6/29/17.
//  Copyright © 2017 Lauren Weiss. All rights reserved.
//

import Foundation
import FirebaseStorage

extension StorageReference {
    static let dateFormatter = ISO8601DateFormatter()
    
    static func newPostImageReference() -> StorageReference {
        //creates an extension to StorageReference with a class method
        //that will generate a new location for each new post image that
        //is created by the current ISO timestamp
        let uid = User.current.uid
        let timestamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("image/posts/\(uid)/\(timestamp).jpg")
    }
    
}
