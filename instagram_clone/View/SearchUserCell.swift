//
//  SearchUserCell.swift
//  instagram_clone
//
//  Created by shin seunghyun on 2020/08/12.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {

    // MARK: - Properties
    
    var user: User? {
        
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            guard let username = user?.username else { return }
            guard let fullname = user?.name else { return }
            profileImageView.loadImage(with: profileImageUrl)
            self.textLabel?.text = username
            self.detailTextLabel?.text = fullname
        }
        
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /*** Configuring Subtitle TableViewCell ***/
        //change super constructor to `subtitle`
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        // add profile image view
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 48, height: 48)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.clipsToBounds = true
        
        /*** TableViewCell Default Hidden Labels ***/
        self.textLabel?.text = "Username"
        self.detailTextLabel?.text = "Full name"
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let textLabel: UILabel = textLabel {
            //x, y의 위치만 바꿔줌
            textLabel.frame = CGRect(x: 68, y: textLabel.frame.origin.y - 2, width: textLabel.frame.width, height: textLabel.frame.height)
            textLabel.font = UIFont.boldSystemFont(ofSize: 12)
        }
        
        if let detailTextLabel: UILabel = detailTextLabel {
            //x, y의 위치만 바꿔줌
            detailTextLabel.frame = CGRect(x: 68, y: detailTextLabel.frame.origin.y, width: detailTextLabel.frame.width, height: detailTextLabel.frame.height)
            detailTextLabel.font = UIFont.systemFont(ofSize: 12)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
