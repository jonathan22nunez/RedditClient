//
//  SubredditsViewController.swift
//  NunezJonathan_CE09
//
//  Created by Jonathan Nunez on 12/12/18.
//  Copyright © 2018 Jonathan Nunez. All rights reserved.
//

import UIKit

class SubredditsViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {
    
    // MARK: Preparations
    @IBOutlet weak var subredditsTableView: UITableView!
    @IBOutlet weak var subredditsToolbar: UIToolbar!
    
    // Empty array of Subreddit objects
    var subreddits = [Subreddit]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        subredditsTableView.dataSource = self
        
        // Edit turns on "Select Mode"
        subredditsTableView.allowsMultipleSelectionDuringEditing = true
        
        // Set title of page
        navigationItem.title = "Subreddits"
        // Create an "Edit" barButtonItem in the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped(_:)))
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Set number of rows in section to the array of Subreddit objects
        return subreddits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = subredditsTableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = "/r/" + subreddits[indexPath.row].subreddit
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove data from dataSource
            self.subreddits.remove(at: indexPath.row)
            // Then remove from tableView
            subredditsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Handle multiselect callback
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.isEditing == true {
            print("Selecting Row: " + indexPath.row.description)
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.isEditing == true {
            print("Unselecting Row: " + indexPath.row.description)
        }
        return indexPath
    }
    
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        // Enter edit mode, and exit edit mode
        subredditsTableView.setEditing(!subredditsTableView.isEditing, animated: true)
        
        if subredditsTableView.isEditing == true {
            // If edit mode is enabled, set leftBarButton to .trash, and call trash all selected method
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(SubredditsViewController.trashAllSelected))
            // If edit mode is enabled, set rightBarButton to .cancel, and call own method
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SubredditsViewController.editTapped(_:)))
            subredditsToolbar.isHidden = true
        }
        else {
            // If edit mode is disabled then the area will become a backBarButtonItem
            navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
            // If edit mode is disabled then reset rightBarButton to .edit
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(SubredditsViewController.editTapped(_:)))
            subredditsToolbar.isHidden = false
        }
    }
    
    @IBAction func resetTapped(_ sender: UIBarButtonItem) {
        // Remove all subreddits
        subreddits.removeAll()
        // Initialize with intial subreddit
        ParseRemoteJSON(subredditString: "samsung")
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        // Create UIAlertController for adding a new subreddit
        let addAlert = UIAlertController(title: "Add New Subreddit", message: "Type in your favorite subreddit", preferredStyle: .alert)
        // Add a textfield w/ placeholder
        addAlert.addTextField { (textField) in
            textField.placeholder = "Enter Subreddit"
        }
        // Add an "Add" button that will use the textField.text to populate a new subreddit
        addAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (alert) in
            let textField = addAlert.textFields![0] as UITextField
            
            self.ParseRemoteJSON(subredditString: textField.text!)
        }))
        // Add a "Cancel" button
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // Present UIAlertController
        self.present(addAlert, animated: true, completion: nil)
    }
    
    // Loop through and delete all the comics and cells that have been selected in edit mode
    @objc func trashAllSelected() {
        // Build alert to confirm deletion of selected lists
        let deleteListsAlert = UIAlertController(title: "Delete Lists", message: "Are you sure you want to delete the list(s)?", preferredStyle: .alert)
        // Add delete button
        deleteListsAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alert) in
            // Get index of all selected rows
            if var selectedIPs = self.subredditsTableView.indexPathsForSelectedRows {
                // Sort in largest to smallest index, so we can remove items from back to front
                selectedIPs.sort { (a, b) -> Bool in
                    a.row > b.row
                }
                for indexPath in selectedIPs {
                    // Update the data (delete list) first
                    self.subreddits.remove(at: indexPath.row)
                }
                
                // Delete all the rows at once
                self.subredditsTableView.deleteRows(at: selectedIPs, with: .left)
            }
        }))
        // Add cancel button
        deleteListsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // Show alert
        self.present(deleteListsAlert, animated: true, completion: nil)
    }
}
