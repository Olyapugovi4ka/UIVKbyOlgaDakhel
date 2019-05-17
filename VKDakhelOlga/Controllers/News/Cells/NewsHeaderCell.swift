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
    
    var user: User? {
        didSet{
            if  let image = user?.avatarName {
            avatarView.avatarImage = UIImage(named: image)!
            }
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
