//
//  MyFriendsController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class MyFriendsController: UITableViewController {
    
    private var users: [User] = [
        User(name: "Susan", avatarImage: UIImage(named: "Friends")),
        User(name: "Serz", avatarImage: UIImage(named: "Friends"))]
    
    var firstLettersSectionTitles = [String]()
    var  allFriendsDictionary = [String: [User]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sortedSections()
        
    }
    
    private func sortedSections() {
        firstLettersSectionTitles = []
        allFriendsDictionary = [:]
        
        for user in users {
            let userNameKey = String(user.name.prefix(1))
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
        return firstLettersSectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       let userNameKey = firstLettersSectionTitles[section]
        if let userValues = allFriendsDictionary[userNameKey] {
            return userValues.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFriendsCell.reuseId, for: indexPath) as? MyFriendsCell else {fatalError("Cell cannot be dequeued")}
        let userNameKey = firstLettersSectionTitles[indexPath.section]
        if let userValues = allFriendsDictionary[userNameKey] {
            
            cell.userLabel.text = userValues[indexPath.row].name
            
        }
        
        return cell

    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return firstLettersSectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return firstLettersSectionTitles
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Friend Photo",
        let photoVC = segue.destination as? FriendsPhotoController,
            let indexPath = tableView.indexPathForSelectedRow {
            let userName = users[indexPath.row].name
            photoVC.friendName = userName
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    @IBAction func addFriend(segue: UIStoryboardSegue){
        if let addFriendController = segue.source as? AddFriendController,
            let indexPath = addFriendController.tableView.indexPathForSelectedRow {
            let friend = addFriendController.users[indexPath.row]
            guard !users.contains(where: { (User) -> Bool in
                return User.name == friend.name
            }) else {return}
            self.users.append(friend)
            sortedSections()
            tableView.reloadData()
        }
        
    }
 

}
