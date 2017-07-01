//
//  LikeService.swift
//  Makestagram
//
//  Created by Lauren Weiss on 6/30/17.
//  Copyright © 2017 Lauren Weiss. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct LikeService {
    //method for liking posts
    static func create(for post: Post, success: @escaping (Bool) -> Void) {
        guard let key = post.key else {
            
            return success(false)
        }
        //reference to the current uses's UID - use this to build the location of where we'll store the data for liking the post
        let currentUID = User.current.uid
        
        let likesRef = Database.database().reference().child("postLikes").child(key).child(currentUID)
        likesRef.setValue(true) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            //success callback returns a Bool based on whether the network request was successfully executed
            //and if our like data was saved to the database
            return success(true)
        }
        //use poster property to build the relative path to the like count location we want to write at
        let likeCountRef = Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")
        likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
            let currentCount = mutableData.value as? Int ?? 0
            
            //increments the like_count of a post after a post has been liked
            mutableData.value = currentCount + 1
            
            return TransactionResult.success(withValue: mutableData)
        }, andCompletionBlock: { (error, _, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success(false)
            } else {
                success(true)
            }
        })
    }
    
    static func isPostLiked(_ post: Post, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        guard let postKey = post.key else {
            assertionFailure("Error: post must have key.")
            return completion(false)
        }
        let likesRef = Database.database().reference().child("postLikes").child(postKey)
        likesRef.queryEqual(toValue: nil, childKey: User.current.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
    })
    }
    
    static func setIsLiked(_ isLiked: Bool, for post: Post, success: @escaping (Bool) -> Void) {
        if isLiked {
            create(for: post, success: success)
        } else {
            delete(for: post, success: success)
        }
    }
    
}
    struct DislikeService {
        static func delete(for post: Post, success: @escaping (Bool) -> Void) {
            guard let key = post.key else {
                return success(false)
            }
            let currentUID = User.current.uid
            
            let likesRef = Database.database().reference().child("postLikes").child(key).child(currentUID)
            //set the value of the location to nil instead of true (like what we did for liking posts) to delete the node at that location
            likesRef.setValue(nil) { (error, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return success(false)
                }
                
                let likeCountRef = Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")
                likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                    let currentCount = mutableData.value as? Int ?? 0
                    
                    mutableData.value = currentCount - 1
                    
                    return TransactionResult.success(withValue: mutableData)
                }, andCompletionBlock: { (error, _, _) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                        success(false)
                    } else {
                        success(true)
                    }
                })
            }
        }
        
}
