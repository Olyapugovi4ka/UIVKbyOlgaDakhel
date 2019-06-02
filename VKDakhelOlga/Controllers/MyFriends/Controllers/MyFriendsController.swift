//
//  MyFriendsController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit


class MyFriendsController: UITableViewController {
    
    //MARK: - Service for requests
    let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
    // MARK: Array of Users(under models)
    public var users:[User] = []
    
    // MARK: Sections
    var firstLettersSectionTitles = [String]()
    var  allFriendsDictionary = [String: [User]]()
   
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Server request
        networkingService.loadFriends { [weak self] responce in
            guard let self = self else { return }
            switch responce {
            case .success(let users):
                self.users = users
                self.sortUsers()
                self.tableView.reloadData()
            case .failure(let error):
                self.show(error)
            }
        }
        
        
    }
    
   //MARK: Controller Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        sortUsers()
        let dotsView = LoadingDotsView()
        view.addSubview(dotsView)
        dotsView.frame = CGRect(x: 100, y: 300, width: 30, height: 10)
        dotsView.startAnimating()
       // dotsView.stopAnimating()
    }
    
    //MARK: Sections
    private func sortUsers() {
        
        firstLettersSectionTitles = []
        allFriendsDictionary = [:]
        
        for user in users {
            let userNameKey = String(user.userName.prefix(1))
            if var userValue = allFriendsDictionary[userNameKey] {
                userValue.append(user)
                allFriendsDictionary[userNameKey] = userValue
            } else {
                allFriendsDictionary[userNameKey] = [user]
            }
        }
        
        firstLettersSectionTitles = [String](allFriendsDictionary.keys)
        firstLettersSectionTitles = firstLettersSectionTitles.sorted(by: {$0 < $1})
        
    }

    // MARK: - Table view data source
    //MARK: Count of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return firstLettersSectionTitles.count
        
    }
    //MARK: Count of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let userNameKey = firstLettersSectionTitles[section]
            if let userValues = allFriendsDictionary[userNameKey] {
            return userValues.count
            }
        return 0
    }
    
    // MARK: Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFriendsCell.reuseId, for: indexPath) as? MyFriendsCell else {fatalError("Cell cannot be dequeued")}
            let userNameKey = firstLettersSectionTitles[indexPath.section]
            if let userValues = allFriendsDictionary[userNameKey] {
                let user = userValues[indexPath.row]
                cell.configer(with: user)
//            cell.userLabel.text = userValues[indexPath.row].userName
//                 let roundPhotoName = userValues[indexPath.row].avatarName
//                    cell.avatarView.avatarImage = UIImage(named:roundPhotoName)!
//
     }
        return cell
    }
    
    //MARK: Title of header of section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return firstLettersSectionTitles[section]
    }
    
    //MARK: Titles of sections
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return firstLettersSectionTitles
    }
    
    //MARK: For deleting
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
        let user = users.remove(at: indexPath.row)
           // users[indexPath.section].remove(at: indexPath.row)
       //tableView.deleteRows(at: [indexPath], with: .fade)
        if let index = users.firstIndex(where: {$0.userName == user.userName}) {
            users.remove(at: index)
            }
            
        }
        sortUsers()
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    // MARK: Show photos of friend
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Friend Photo",
            let photoVC = segue.destination as? FriendsPhotoController {
            if let selectedCell = sender as? MyFriendsCell {
                let indexPath = tableView.indexPath(for: selectedCell)!
                let userNameKey = firstLettersSectionTitles[indexPath.section]
                    if let userValues = allFriendsDictionary[userNameKey] {
                        let userName = userValues[indexPath.row].userName
                        photoVC.friendName = userName
                        let userId = userValues[indexPath.row].userId
                        photoVC.userId = userId
                        if let photos = userValues[indexPath.row].photos {
                            photoVC.photosInFriendsPhotoController = photos
                        }
                    }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        print(cell?.detailTextLabel?.text ?? "nil")
        }
    
    //MARK: Adding new friend
    @IBAction func addFriend(segue: UIStoryboardSegue){
        
        if let addFriendController = segue.source as? AddFriendController,
            let indexPath = addFriendController.tableView.indexPathForSelectedRow {
            let friend = addFriendController.users[indexPath.row]
            guard !users.contains(where: { (User) -> Bool in
                return User.userName == friend.userName
            }) else {return}
            self.users.append(friend)
            self.sortUsers()
            tableView.reloadData()
        }
        
    }


}
