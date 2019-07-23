//
//  NewsImageCell.swift
//  VKDakhelOlga
//
//  Created by MacBook on 25/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import Kingfisher

class NewsImageCell: UITableViewCell {
    
      static let reusedId = "NewsImageCell"
    
    @IBOutlet weak var newsImage: UIImageView!
    
    public func configer (with photo: Photo) {
//        let countOfLikes = String(photo.numberOfLikes)
//        likeControl.likesCount.text = countOfLikes
        
        let imageString = photo.name
        let imageUrl = URL(string: imageString)
        newsImage.kf.setImage(with: imageUrl)
        
    }
}
