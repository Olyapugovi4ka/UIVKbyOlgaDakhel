//
//  File.swift
//  VKDakhelOlga
//
//  Created by MacBook on 09/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import SwiftyJSON

class Group {
    
    //MARK: - Properties
    let name: String
    var avatarName: String?
    
    //MARK: - Initialisation
    init(_ json:JSON){
        self.name = json["name"].stringValue
        self.avatarName = json["photo_200"].stringValue
    }
}

