//
//  UserService.swift
//  Makestagram
//
//  Created by Lauren Weiss on 6/27/17.
//  Copyright © 2017 Lauren Weiss. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase


struct UserService {
    //  The service struct will act as an intermediary for communicating between our app and Firebase.
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        //class method for reading a user from the database
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            completion(user)
        })
    }
    
    
    
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func posts(for user: User, completion: @escaping ([Post]) -> Void) {
        //retrieves all of the user's posts from Firebase
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let dispatchGroup = DispatchGroup()
            
            let posts: [Post] =
            snapshot
                .reversed()
                .flatMap {
                    guard let post = Post(snapshot: $0)
                        else { return nil}
                    dispatchGroup.enter()
                    LikeService.isPostLiked(post) { (isLiked) in
                        post.isLiked = isLiked
                        dispatchGroup.leave()
                    }
                    return post
            }
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
            })
            })
}
}
