//
//  MyFriendsController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import RealmSwift


class MyFriendsController: UITableViewController {
    
    //MARK: - Service for requests
    let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
    // MARK: - Array of Users(under models)
    public var users: Results<User> = try! RealmProvider.get(User.self)
    
    // MARK: - Sections
    fileprivate var firstLettersSectionTitles = [String]()
    fileprivate var  allFriendsDictionary = [String:Results<User>]()
    
    //MARK: - Array fo users, after using SearchBar
    fileprivate var searchedUsers = [User]()
    
    //MARK: - Outlet for SerchBar
    @IBOutlet var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    //MARK: - Notification token
    var notificationToken: NotificationToken?
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchDataOperation = FetchDataOperation(request: )
        let parseOperation = ParseDataOperation()
        parseOperation.addDependency(fetchDataOperation)
        let persistOperation = PersistDataOperation()
        persistOperation.addDependency(parseOperation)
        
        
        //MARK: - Server request
//        networkingService.loadFriends { [weak self] responce in
//            guard let self = self else { return }
//            switch responce {
//            case .success(let users):
//                try! RealmProvider.save(items: users)
//                //self.users = users
//                self.firstLettersSectionTitles = self.sortUsers(self.users)
//                self.tableView.reloadData()
//            case .failure(let error):
//                self.show(error)
//            }
//        }
//
        notificationToken = users.observe{ [weak self]  change in
            switch change {
            case .initial:
                self?.tableView.reloadData()
            case . update:
                self?.tableView.reloadData()
            case .error(let error):
                self?.show(error)
            }
        }
//        firstLettersSectionTitles = []
//        allFriendsDictionary = [:]
    }
    
   //MARK: - Controller Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: Invalidation of notification token
        notificationToken?.invalidate()
    }
    
    
    //MARK: - Sections
    private func sortUsers(_ users: Results<User>) -> [String] {
        
        firstLettersSectionTitles = []
       // allFriendsDictionary = [:]
        
        for user in users {
            let userNameKey = String(user.userName.prefix(1))
            if !firstLettersSectionTitles.contains(userNameKey){
                firstLettersSectionTitles.append(userNameKey)
            }
            
           //firstLettersSectionTitles = [String](allFriendsDictionary.keys)
       
        }
        //firstLettersSectionTitles = [String](allFriendsDictionary.keys)
        return  firstLettersSectionTitles.sorted(by: {$0 < $1})
    }
    
    //MARK: - Table view data source
    //MARK: - Count of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return firstLettersSectionTitles.count
        
    }
    //MARK: -Count of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let userNameKey = String(firstLettersSectionTitles[section])
        let predicate = NSPredicate(format:"userName BEGINSWITH %@", userNameKey )
        if let searchText = searchBar.text, !searchText.isEmpty {
            let sectionUsers = users.filter(predicate).filter("userName CONTAINS[cd] %@",searchText)
            return sectionUsers.count
        } else {
            let sectionUsers = users.filter(predicate)
            return sectionUsers.count
        }
    }
    
    // MARK: Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFriendsCell.reuseId, for: indexPath) as? MyFriendsCell else {fatalError("Cell cannot be dequeued")}
        let userNameKey = firstLettersSectionTitles[indexPath.section]
        let userValues: Results<User> = {
            if let searchText = searchBar.text, !searchText.isEmpty {
                return users.filter("userName BEGINSWITH %@", userNameKey)
                    .filter("userName CONTAINS[cd] %@",searchText)
            } else {
                return users.filter("userName BEGINSWITH %@", userNameKey)
            }
        }()
        
        let user = userValues[indexPath.row]
        cell.configer(with: user)
        
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
            let user = users[indexPath.row]
            try! RealmProvider.delete(items: user)
        }
    }
    
    // MARK: - Navigation
    
    // MARK: Show photos of friend
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Friend Photo",
            let photoVC = segue.destination as? FriendsPhotoController,
            let indexPath = tableView.indexPathForSelectedRow {
            let userNameKey = firstLettersSectionTitles[indexPath.section]
            let userValues: Results<User> = {
                if let searchText = searchBar.text, !searchText.isEmpty {
                    return users.filter("userName BEGINSWITH %@", userNameKey)
                        .filter("userName CONTAINS[cd] %@",searchText)
                } else {
                    return users.filter("userName BEGINSWITH %@", userNameKey)
                }
            }()

            let userName = userValues[indexPath.row].userName
            photoVC.friendName = userName
            
            let userId = userValues[indexPath.row].userId
            photoVC.userId = userId
            
        }
    
    
    }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        print(cell?.detailTextLabel?.text ?? "nil")
        }
    
    //MARK: Adding new friend
//    @IBAction func addFriend(segue: UIStoryboardSegue){
//
//        if let addFriendController = segue.source as? AddFriendController,
//            let indexPath = addFriendController.tableView.indexPathForSelectedRow {
//            let friend = addFriendController.users[indexPath.row]
//            guard !users.contains(where: { (User) -> Bool in
//                return User.userName == friend.userName
//            }) else {return}
//            self.users.append(friend)
//            self.sortUsers()
//            tableView.reloadData()
//        }
//
//    }

//    let dotsView = LoadingDotsView()
//    view.addSubview(dotsView)
//    dotsView.frame = CGRect(x: 100, y: 300, width: 30, height: 10)
//    dotsView.startAnimating()
//    dotsView.stopAnimating()
}

//MARK: SearchBar
extension MyFriendsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            searchedUsers = Array(users)
            firstLettersSectionTitles = sortUsers(self.users)
            tableView.reloadData()
            return
        }
        let filteredUsers = self.users.filter("name CONTAINS[cd]'\(searchText)")
        firstLettersSectionTitles = sortUsers(filteredUsers)
        tableView.reloadData()
    }
    
}
