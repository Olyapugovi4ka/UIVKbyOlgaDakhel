//
//  ReloadTableController.swift
//  VKDakhelOlga
//
//  Created by MacBook on 27/07/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class ReloadTableController: Operation {
    var controller: UITableViewController
    
    init( contoller: UITableViewController) {
        self.controller = controller
    }
    override func main() {
        quard let persistData = dependencies
        .filter({ $0 is PersistDataOperation})
            .first as? PersistDataOperation else { return}
        controller.
    }
}
