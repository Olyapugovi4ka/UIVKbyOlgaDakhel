//
//  TableViewController.swift
//  VKDakhelOlga
//
//  Created by MacBook on 25/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import RealmSwift

class NewsController: UITableViewController {
   
    //MARK: - Service for requests
    let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
    //MARK: - Observer
    var notificationToken: NotificationToken?
    
    let news: Results<News> = try! RealmProvider.get(News.self)
    let group: Results<Group> = try! RealmProvider.get(Group.self)
    let user: Results<User> = try! RealmProvider.get(User.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Server request
        networkingService.loadNews {[weak self] responce in
            //MARK: - creating a queue
            let queue = DispatchQueue.global(qos: .userInitiated)
            queue.async {
                
                guard let self = self else { return }
                switch responce {
                case .success(let newsResponse):
                    do {
                        let news = newsResponse.news
                        try RealmProvider.save(items: news)
                        let groups = newsResponse.groups
                        try RealmProvider.save(items: groups)
                        let users = newsResponse.users
                        try RealmProvider.save(items: users)
                    } catch {
                        print ("No data")
                    }
                case .failure(let error):
                    self.show(error)
                }
            }
        }
        
        notificationToken = news.observe { change in
            switch change {
            case .initial:
                self.tableView.reloadData()
            case .update:
                self.tableView.reloadData()
            case .error(let error):
                self.show(error)
            }
        }
    }

    // MARK: - Table view data source
    
    //MARK: Count of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return news.count
    }

    //MARK: Count of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 4
    }
    
    //MARK: Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        //MARK: First row
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHeaderCell", for: indexPath) as! NewsHeaderCell
            let sourceId = news[indexPath.section].sourceId
            do {
                if sourceId > 0 {
                    let user = try Realm().object(ofType: User.self, forPrimaryKey: sourceId)
                    cell.userLabel.text = user?.userName
                    if let imageString = user?.avatarName,
                        let imageURL = URL(string: imageString){
                        cell.avatarView.clippedImageView.kf.setImage(with: imageURL)
                    }
                } else {
                    let group = try Realm().object(ofType: Group.self, forPrimaryKey: -sourceId)
                    cell.userLabel.text = group?.name
                    if let imageString = group?.avatarName,
                        let imageURL = URL(string: imageString) {
                        cell.avatarView.clippedImageView.kf.setImage(with: imageURL)
                    }
                }
            } catch {
                print ("No user and no group")
            }
        
            return cell
        //MARK: Second row
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as! NewsTextCell
             let text = news[indexPath.section].newsText
            
            //MARK: - returning to main queue
            DispatchQueue.main.async {
                cell.textField.text = text
            }
            
            return cell
            //MARK: Third row
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell", for: indexPath) as! NewsImageCell
//            if let imageString = news[indexPath.section].newsPhoto?.name,
//                let imageUrl = URL(string: imageString ){
//                    cell.newsImage.image = UIImage(named: image)
//            }
            if let photo = news[indexPath.section].newsPhoto {
            cell.configer(with: photo)
            }
            return cell
            //MARK: Forth row
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsControlCell", for: indexPath) as! NewsControlCell
            return cell
            //MARK: Other cases
        default:
            return UITableViewCell()
        }
    }
    
}
//MARK: - size of NewsTextCell
//extension NewsController{
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as! NewsTextCell
//        var height = cell.textField.bounds.height
//        if cell.textField.text.isEmpty{
//            height = 0
//        }
//        return height
//    }
//
//}
