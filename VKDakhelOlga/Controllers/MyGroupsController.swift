//
//  MyGroupsController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class MyGroupsController: UITableViewController {
    
    private var groups:[Group] = [
        Group(name:"The Swift Developers"),
        Group(name: "Vandrouki")]
    var firstLettersSectionTitles = [String]()
    var allGroupsDictionary = [String: [Group]]()

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
        allGroupsDictionary = [:]
        
        for group in groups {
            let groupNameKey = String(group.name.prefix(1))
            if var newGroup = allGroupsDictionary[groupNameKey] {
                newGroup.append(group)
                allGroupsDictionary[groupNameKey] = newGroup
            } else {
                allGroupsDictionary[groupNameKey] = [group]
            }
        }
        firstLettersSectionTitles = [String](allGroupsDictionary.keys)
        firstLettersSectionTitles = firstLettersSectionTitles.sorted(by: {$0 < $1})
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return firstLettersSectionTitles.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       let groupNameKey = firstLettersSectionTitles[section]
        if let newGroup = allGroupsDictionary[groupNameKey]{
      return newGroup.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.reuseId, for: indexPath) as? GroupCell else {fatalError("Cell cannot be dequeued")}
        let groupNameKey = firstLettersSectionTitles[indexPath.section]
        if let newGroup = allGroupsDictionary[groupNameKey] {
           cell.GroupNameLabel.text = newGroup[indexPath.row].name
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
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    //}
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if let addGroupController = segue.source as? AddGroupController,
            let indexPath = addGroupController.tableView.indexPathForSelectedRow {
            let newGroup = addGroupController.groups[indexPath.row]
            guard !groups.contains(where: { (Group) -> Bool in
                return Group.name == newGroup.name
            }) else {return}
            self.groups.append(newGroup)
            self.sortedSections()
            tableView.reloadData()
        //    let newIndexPath = IndexPath(item: groups.count-1, section: 0)
        //    tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
    }

}
