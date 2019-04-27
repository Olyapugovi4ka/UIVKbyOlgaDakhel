//
//  MyGroupsController.swift
//  VK_OlgaDakhel
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

class MyGroupsController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    private var groups:[Group] = [
        Group(name:"The Swift Developers"),
        Group(name: "Vandrouki")]
    
    var firstLettersSectionTitles = [String]() //for sorting
    var allGroupsDictionary = [String: [Group]]() // for sorting
    
    private var filteredGroups = [Group]() // For searcBar
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredGroups = groups
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sortedSections()
    }
    
    // MARK: function for forming sections
    private func sortedSections() {
        
        firstLettersSectionTitles = []
        allGroupsDictionary = [:]
        
        for group in filteredGroups {
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
    // MARK: function for searchBar
    private func filterGroups (with text: String) {
        filteredGroups = groups.filter{ group in
            return group.name.lowercased().contains(text.lowercased())
        }
        tableView.reloadData()
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
    
    //MARK: FOR DELETING
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let group = filteredGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let index = groups.firstIndex(where: {$0.name == group.name}){
            groups.remove(at:index)
            }
        }
        
    }
    //MARK: ADDINNG NEW ITEM
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        
        if let addGroupController = segue.source as? AddGroupController,
            let indexPath = addGroupController.tableView.indexPathForSelectedRow {
            let newGroup = addGroupController.groups[indexPath.row]
            guard !groups.contains(where: { (Group) -> Bool in
                return Group.name == newGroup.name
            }) else {return}
            self.groups.append(newGroup)
            filteredGroups = groups
            self.sortedSections()
            tableView.reloadData()
        }
        
    }
    
}
extension MyGroupsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredGroups = groups
            tableView.reloadData()
            return
        }
        filterGroups(with: searchText)
    }
    
}
