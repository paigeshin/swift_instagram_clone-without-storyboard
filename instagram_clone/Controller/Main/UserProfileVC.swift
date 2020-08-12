//
//  UserProfileVC.swift
//  instagram_clone
//
//  Created by shin seunghyun on 2020/08/11.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

private let reuseIdentifier = "Cell"
private let headerIdentifier = "UserProfileHeader"
private let footerIdentifier = "UserProfileFooter"

class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    var currentUser: User?
    
    var userToLoadFromSearch: User? 

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        /***** Create Header *****/
        /**** Take a closer look at this API. Second argument of the parameter should be `forSupplementaryViewOfKind`  ****/
        self.collectionView!.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        //If you want to add footer...
//        self.collectionView!.register(UserProfileFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        
                
        //background color
        collectionView.backgroundColor = .white

        if userToLoadFromSearch == nil {
            fetchCurrentUserData()
        }
    }


    // MARK: UICollectionViewDataSource
    
    /***** Create Header *****/
    //If you added header or footer, you can increment `return` values 
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }


    /***** Create Header *****/
    //dequeue reusable cell
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // declare header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader
        header.delegate = self
        if let user = self.currentUser {
            header.user = user
        } else if let userToLoadFromSearch = self.userToLoadFromSearch {
            header.user = userToLoadFromSearch
            navigationItem.title = userToLoadFromSearch.username
        }
        return header
        
        /**** Other ways to configure header and footer ****/
//        switch kind {
//
//        case UICollectionView.elementKindSectionHeader:
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader
//            return headerView
//        case UICollectionView.elementKindSectionFooter:
//            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! UserProfileFooter
//            return footerView
//         default:
//
//             fatalError("Unexpected element kind")
//         }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }

    
    /***** Create Header *****/
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        
//    }
    
    
    func fetchCurrentUserData() {
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

        if let currentUid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                let uid = snapshot.key
                let user = User(uid: uid, dictionary: dictionary)
                self.navigationItem.title = user.username
                //set global variable user
                self.currentUser = user
                self.collectionView.reloadData()
            }
        }
    }
    
}

extension UserProfileVC: UserProfileHeaderDelegate {
    
    func handleFollowersTapped(for header: UserProfileHeader) {
        
        
    }
    
    func handleFollowingTapped(for header: UserProfileHeader) {
        
    }
    
    func handleEditProfileFollow(for header: UserProfileHeader) {
        
        print("handle edit profile is called!")
        
        guard let user = header.user else { return }
        
        //Text가 Edit Profile이면, Profile 수정하는 화면으로 보내줌.
        //edit profile
        if header.editProfileFollowButton.titleLabel?.text == "Edit Profile" {
            
            print("Go To EditProfileController")

//            let editProfileController = EditProfileController()
//            let editProfileController.user = user
//            editProfileController.userProfileController = self
//            let navigationController = UINavigationController(rootViewController: editProfileController)
//            present(navigationController, animated: true, completion: nil)
            
        } else {
            
            print("Not Edit Profile")
            //Text가 Follow로 되어있으면 follow()를
            //Text가 Following로 되어있으면 unfollow()를 호출한다
            if header.editProfileFollowButton.titleLabel?.text == "Follow" {
                print("Title is Follow")
                header.editProfileFollowButton.setTitle("Following", for: .normal)
                user.follow()
            } else {
                header.editProfileFollowButton.setTitle("Follow", for: .normal)
                user.unfollow()
            }
            
        }
        
    }
    
    func setUserStatus(for header: UserProfileHeader) {
        
        guard let uid = header.user?.uid else { return }
        
        var numberOfFollowers: Int!
        var numberOfFollowing: Int!
        
        // get number of followers
        USER_FOLLOWERS_REF.child(uid).observe(.value) { (snapshot) in
             if let snapshot = snapshot.value as? Dictionary<String,AnyObject> {
                numberOfFollowers = snapshot.count
                self.setText(label: header.followersLabel, number: numberOfFollowers)
            } else {
                self.setText(label: header.followersLabel, number: 0)
            }
        }
        
        // get number of following
        USER_FOLLOWING_REF.child(uid).observe(.value) { (snapshot) in
            if let snapshot = snapshot.value as? Dictionary<String,AnyObject> {
                numberOfFollowing = snapshot.count
                self.setText(label: header.followingLabel, number: numberOfFollowing)
            } else {
                self.setText(label: header.followingLabel, number: 0)
            }
        }
  
        
    }
    
    
    private func setText(label: UILabel, number: Int) {
        label.textAlignment = .center
          let attributedText = NSMutableAttributedString(string: "\(number)\n", attributes:
              [
                  NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)
              ]
          )
          attributedText.append(NSAttributedString(string: "follwing", attributes:
                  [
                      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                      NSAttributedString.Key.foregroundColor: UIColor.lightGray
                  ]
              )
          )
          label.attributedText = attributedText
    }
    
}
