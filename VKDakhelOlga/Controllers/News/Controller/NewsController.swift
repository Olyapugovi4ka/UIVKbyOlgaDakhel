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
    
    //MARK: - Properties
    
    //MARK: - For NewsTextCell
    var textIsEmpty: Bool = true
   
    //MARK: - For NewsImageCell
    var maxWidth: CGFloat {
            return self.view.bounds.width
    }
   
    //MARK: - Service for requests
    //MARK: - proxy
    private let proxy = NetworkingServiceProxy()
    
    //MARK: - Observer
    var notificationToken: NotificationToken?
    
    let news: Results<News> = try! RealmProvider.get(News.self)
    let group: Results<Group> = try! RealmProvider.get(Group.self)
    let user: Results<User> = try! RealmProvider.get(User.self)
    let nextFrom: String = ""

    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Server request
        proxy.loadNews(startFrom: nextFrom) {[weak self] responce in
            
            //MARK: - Creating a queue for fetching and parsing
            let queue = DispatchQueue.global(qos: .userInitiated)
            queue.async {
                
                guard let self = self else { return }
                switch responce {
                case .success(let newsResponse):
                    do {
                        let news = newsResponse.news.sorted(by: { $0.date < $1.date})
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
    
    //MARK: - Count of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return news.count
    }

    //MARK: - Count of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 4
    }
    
    //MARK: Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
            
        //MARK: - NewsHeaderCell for avatar and name
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHeaderCell", for: indexPath) as? NewsHeaderCell else { return UITableViewCell()}
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
            
        //MARK: - NewsTextCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as! NewsTextCell
            if let text = news[indexPath.section].newsText{
                cell.textField.text = text
            
            }
            return cell
            
            //MARK: - NewsImageCell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell", for: indexPath) as! NewsImageCell

            if let photo = news[indexPath.section].newsPhoto {
                cell.configer(with: photo)
            }
            return cell
            
            //MARK: - NewsControlCell for likes, reposts and comments
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsControlCell", for: indexPath) as! NewsControlCell
            let likeCount = news[indexPath.section].likeCount
            let userLikes = news[indexPath.section].userLikes
            cell.configer(with: userLikes)
            let commentsCount = news[indexPath.section].commentsCount
            let repostsCount = news[indexPath.section].repostsCount
            
            DispatchQueue.main.async {
                cell.likeLabel.text = String(likeCount)
                cell.commentLabel.text = String(commentsCount)
                cell.repostLabel.text = String(repostsCount)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
}

//MARK: - size of NewsTextCell
extension NewsController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.row {
            
        case 1:
            if let text = news[indexPath.section].newsText,
                !text.isEmpty {
                return UITableView.automaticDimension
            } else { return 0 }
            
        case 2:
            guard let photo = news[indexPath.section].newsPhoto,
                let aspectRatio = photo.aspectRatio else { return 1 }
            if photo.photoId == 0 {
                return 1
            } else {
                return tableView.bounds.width / CGFloat(aspectRatio)
            }
            
        case 3:
            return 35
            
        default:
            return UITableView.automaticDimension
        }
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
