//
//  NewsHeaderCell.swift
//  VKDakhelOlga
//
//  Created by MacBook on 25/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import Kingfisher


class NewsHeaderCell: UITableViewCell {
    
    static let reusedId = "NewsHeaderCell"
    
    
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var userLabel: UILabel!
    
    public func configer ( with user: User) {
        
        userLabel.text = user.userName
        
        let imageString = user.avatarName
        let imageURL = URL(string: imageString)
        avatarView.clippedImageView.kf.setImage(with: imageURL)
        
    }

}
