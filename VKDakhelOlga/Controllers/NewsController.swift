//
//  TableViewController.swift
//  VKDakhelOlga
//
//  Created by MacBook on 25/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {
    
    let news:[News] = [News(userName: "Marina", avatarImage: UIImage(named: "Friends"), newsText: "Hellow", newsPhoto: UIImage(named: "flame"))]
    
   

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return news.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHeaderCell", for: indexPath) as! NewsHeaderCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as! NewsTextCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell", for: indexPath) as! NewsImageCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsControlCell", for: indexPath) as! NewsControlCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
