//
//  User.swift
//  instagram_clone
//
//  Created by shin seunghyun on 2020/08/11.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//

//NOSQL Based UserModel Definition, especially for firebase
/*
How data is stored
 users: {
    FGvQSt4vGCh5zsB6z8crWjQOAzO2 : {
        name: "user"
        profileImageUrl: "http://url"
        username: "username"
    }
 }
*/

import FirebaseAuth
import FirebaseDatabase

let USER_FOLLOWERS_REF = Database.database().reference().child("user_followers")
let USER_FOLLOWING_REF = Database.database().reference().child("user_following")


class User {
    
    // attributes
    var username: String!
    var name: String!
    var profileImageUrl: String!
    var uid: String!
    
    var isFollowed = false
    
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
        
        self.uid = uid
        
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
            self.profileImageUrl = profileImageUrl
        }
        
    }
    
    func follow() {
        
        //나의 id
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // UPDATE: - get uid like this to work with update
        //상대 id
        guard let uid = uid else { return }
        
        if currentUid == uid {
            return
        }
        
        // set is followed to true
        self.isFollowed = true
        
        // add followed user to current user-following structure
        USER_FOLLOWING_REF.child(currentUid).updateChildValues([uid: 1])
        
        // add current user to followed user-follower sturucture
        USER_FOLLOWERS_REF.child(uid).updateChildValues([currentUid: 1])
        
        // upload follow notification to server
        
        // add followed users posts to current user-feed
        
        
    }
    
    func unfollow() {
        
        //나의 id
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // UPDATE: - get uid like this to work with update
        //상대 id
        guard let uid = uid else { return }
        
        if currentUid == uid {
            return
        }
        
        // set is followed to false
        self.isFollowed = false
        
        // remove followed user to current user-following structure
        USER_FOLLOWING_REF.child(currentUid).child(uid).removeValue()
        
        // add current user to followed user-follower sturucture
        USER_FOLLOWERS_REF.child(uid).child(currentUid).removeValue()
        
    }
    
    func checkIfUserIsFollowed(completion: @escaping(Bool) -> Void) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_FOLLOWING_REF.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.hasChild(self.uid) {
                
                self.isFollowed = true
                completion(true)
                
            } else {
                
                self.isFollowed = false
                completion(false)
                
            }
            
        }
        
    }
    
    
}
