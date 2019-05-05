//
//  MyFriendsController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class MyFriendsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var SearchBar: UISearchBar!
    var users: [User] = [
        User(userName: "Susan", avatarImage: [UIImage(named: "Friends")]),
        User(userName: "Serz", avatarImage: [UIImage(named: "Friends")])]
    
    var firstLettersSectionTitles = [String]()
    var  allFriendsDictionary = [String: [User]]()
    
    var filterUsers = [User]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sortedSections()
        
        let dotsView = LoadingDotsView()
        view.addSubview(dotsView)
        dotsView.frame = CGRect(x: 100, y: 300, width: 30, height: 10)
        dotsView.startAnimating()
        
        let points = Indicator()
        view.addSubview(points)
        points.frame = CGRect(x: 200, y: 300, width: 30, height: 10)
       
       // dotsView.stopAnimating()
        
    }
    
    private func sortedSections() {
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        if searching {
            return 1
        }
        return firstLettersSectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filterUsers.count
        } else {
            let userNameKey = firstLettersSectionTitles[section]
            if let userValues = allFriendsDictionary[userNameKey] {
            return userValues.count
            }
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFriendsCell.reuseId, for: indexPath) as? MyFriendsCell else {fatalError("Cell cannot be dequeued")}
        if searching {
            cell.userLabel.text = filterUsers[indexPath.row].userName
        } else {
            let userNameKey = firstLettersSectionTitles[indexPath.section]
            if let userValues = allFriendsDictionary[userNameKey] {
            cell.userLabel.text = userValues[indexPath.row].userName
            }
        }
        
        return cell

    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searching {
            return nil
        }
        return firstLettersSectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searching {
            return nil
        }
        return firstLettersSectionTitles
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Friend Photo",
        let photoVC = segue.destination as? FriendsPhotoController,
            let indexPath = tableView.indexPathForSelectedRow {
            let userName = users[indexPath.row].userName
            photoVC.friendName = userName
            let photos = users[indexPath.row].avatarImage
            photoVC.photoInFriendsPhotoController = photos as! [UIImage]
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    @IBAction func addFriend(segue: UIStoryboardSegue){
        if let addFriendController = segue.source as? AddFriendController,
            let indexPath = addFriendController.tableView.indexPathForSelectedRow {
            let friend = addFriendController.users[indexPath.row]
            guard !users.contains(where: { (User) -> Bool in
                return User.userName == friend.userName
            }) else {return}
            self.users.append(friend)
            sortedSections()
            tableView.reloadData()
        }
        
    }
    func searchBar (_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterUsers = users.filter({$0.userName.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
