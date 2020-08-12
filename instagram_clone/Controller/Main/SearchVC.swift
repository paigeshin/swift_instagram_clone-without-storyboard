//
//  SearchVC.swift
//  instagram_clone
//
//  Created by shin seunghyun on 2020/08/11.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//

import UIKit
import FirebaseDatabase

private let reuseIdentifier = "SearchUserCell"

class SearchVC: UITableViewController {
    
    // MARK: - Properties
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell classes
        tableView.register(SearchUserCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // seperator insets => profile 부분은 밑줄을 지워줌.
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
        
        // configure nav controller
        configureNavController()
        
        // fetch users
        fetchUsers()
        
    }

    //Section refers to `Header` or `Footer`
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchUserCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    //tableView delegate method for height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let user = users[indexPath.row]
        
        // create instance of user profile vc
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        
        // passes user from serachVC to userProfileVC
        userProfileVC.userToLoadFromSearch = user
        
        // push view controller
        navigationController?.pushViewController(userProfileVC, animated: true)
        
    }

    
    // MARK: - Handlers
    
    func configureNavController() {
        navigationItem.title = "Explore"
    }
    
    // MARK: - API
    func fetchUsers() {
        /*
        Snap (MsV0OJ2ecuUBqKagdp86r4jH1oH2) {
            name = Power;
            profileImageUrl = "https://firebasestorage.googleapis.com/v0/b/iopaigeinstagramclone.appspot.com/o/profile_images%2FDBBA67D0-1ADE-4D29-867B-C175175CE1E9?alt=media&token=9bb70369-76ee-4feb-b49e-75b1a3c861c7";
            username = Power;
        }
        */
        
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            
            // uid
            let uid = snapshot.key
            
            // snapshot value case as dictionary
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            // construct user
            let user = User(uid: uid, dictionary: dictionary)
            
            // append user to data source
            self.users.append(user)
            
            // reload our table VIEW
            self.tableView.reloadData()
            
        }
        
    }

}
