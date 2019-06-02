//
//  Photo.swift
//  VKDakhelOlga
//
//  Created by MacBook on 09/05/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Photo {
    
    //MARK: - Properties
    var userId: Int
    var name: String
    var numberOfLikes: Int
    
    //MARK: - Initialisation
    init(_ json: JSON){
        self.userId = json["owner_id"].intValue
        self.name = json["sizes"][3]["url"].stringValue
        self.numberOfLikes = json["likes"]["count"].intValue
    }
        
  
}
