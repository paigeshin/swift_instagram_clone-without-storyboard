//
//  FeedVC.swift
//  instagram_clone
//
//  Created by shin seunghyun on 2020/08/11.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "Cell"

class FeedVC: UICollectionViewController {

    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // configure logout button on navigation bar
        configureLogoutButton()
    }



    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
    
    
        return cell
    }

    // MARK: - Handlers
    
    func configureLogoutButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            print("try to attempt to sign out")
            do {
                print("doing its work")
                // attempt sign out
                try Auth.auth().signOut()
                // present login controller
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .overCurrentContext
                self.tabBarController?.tabBar.isHidden = true
                self.present(navController, animated: false) {
                    self.dismiss(animated: false, completion: nil)
                }
            } catch {
                print("Failed to sign out: \(error.localizedDescription)")
            }
        }))
        present(alertController, animated: true, completion: nil)
    }

}
