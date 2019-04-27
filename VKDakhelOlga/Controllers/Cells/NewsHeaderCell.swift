//
//  NewsHeaderCell.swift
//  VKDakhelOlga
//
//  Created by MacBook on 25/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class NewsHeaderCell: UITableViewCell {
    
      static let reusedId = "NewsHeaderCell"
    
    
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var userLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
