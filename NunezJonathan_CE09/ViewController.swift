//
//  ViewController.swift
//  NunezJonathan_CE09
//
//  Created by Jonathan Nunez on 12/12/18.
//  Copyright © 2018 Jonathan Nunez. All rights reserved.
//

// ICON ATTRIBUTION
//<div>Icons made by <a href="https://www.freepik.com/" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Preparations
    @IBOutlet weak var redditPostsTableView: UITableView!
    
    // Empty array of Subreddit objects
    var subredditsList = [Subreddit]()
    // Initial subreddit for new loads
    let initialSubreddit = "samsung"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set tableView dataSource to self
        redditPostsTableView.dataSource = self
        
        // Chcck if there is a saved tableViewColor
        if let hasSavedTableViewColor = UserDefaults.standard.getColor(forKey: "tableViewColor") {
            // Set tableView backgroundColor to the saved tableViewColor
            redditPostsTableView.backgroundColor = hasSavedTableViewColor
        }
        
        // Check if there are any saved subreddits
        if let data = UserDefaults.standard.object(forKey: "subredditsList") as? Data {
            // Create default JSONDecoder
            let jsonDecoder = JSONDecoder()
            
            do {
                // Try decode the data as an array of Subreddit objects
                let savedSubredditsList = try jsonDecoder.decode([Subreddit].self, from: data)
                // Set the subredditsList array to the value of saved Subreddit objects
                subredditsList = savedSubredditsList
                // Update the tableView
                redditPostsTableView.reloadData()
            }
            catch {
                // If there is an error with decoding, then populate the list with the initial subreddit
                ParseRemoteJSON(subredditString: initialSubreddit)
            }
        }
        else {
            // If anything there is no saved data, then populate the list with the initial subreddit
            ParseRemoteJSON(subredditString: initialSubreddit)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Set number of sections to the subredditsList count
        return subredditsList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Set section header title to subreddit name
        return "/r/" + subredditsList[section].subreddit
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Set number of rows in each section to the number of redditposts in each subreddit
        return subredditsList[section].redditPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = redditPostsTableView.dequeueReusableCell(withIdentifier: "reuseID", for: indexPath)
        
        // Check if there is a saved tableViewCell color
        if let hasSavedTableCellColor = UserDefaults.standard.getColor(forKey: "tableCellColor") {
            // Set the cell backgroundColor to that of the saved tableViewCell color
            cell.backgroundColor = hasSavedTableCellColor
        }
        // Get the subreddit in each section
        let redditPosts = subredditsList[indexPath.section].redditPosts
        // Get the posts in each subreddit
        let redditPost = redditPosts[indexPath.row]
        
        cell.textLabel?.text = redditPost.title
        cell.detailTextLabel?.text = redditPost.author
        // Check if thumbnailString is a valid "http" string
        if redditPost.thumbnailString.contains("http") {
            // Test if the string can be a valid URL
            if let validURL = URL(string: redditPost.thumbnailString) {
                do {
                    // Attempt to set the cell imageView to that of the thumbnail
                    let data = try Data(contentsOf: validURL)
                    cell.imageView?.image = UIImage(data: data)
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        // Check if there is a saved tableViewCell text color
        if let hasSavedTableTextColor = UserDefaults.standard.getColor(forKey: "tableTextColor") {
            // Set the tableViewCell text colors
            cell.textLabel?.textColor = hasSavedTableTextColor
            cell.detailTextLabel?.textColor = hasSavedTableTextColor
        }
        
        return cell
    }
    
    // MARK: Actions
    
    @IBAction func subredditsBarButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toSubredditsPage", sender: self)
    }
    
    @IBAction func themesBarButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toThemesPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the current subreddits available to the SubredditsViewController
        if segue.identifier == "toSubredditsPage" {
            if let destination = segue.destination as? SubredditsViewController {
                destination.subreddits = subredditsList
            }
        }
    }
    
    // Unwind method when "Save" button is pressed in ThemesViewController
    @IBAction func unwindFromThemesSave(_ segue: UIStoryboardSegue) {
        if let source = segue.source as? ThemesViewController {
            // Set the tableView backgroundColor to that of the source.tableView backgroundColor
            redditPostsTableView.backgroundColor = source.colorDemoTableView.backgroundColor
            // Create a temporary cell using the cell values from the source.tableView
            let cell = source.colorDemoTableView.cellForRow(at: IndexPath(row: 0, section: 0))
            // Iterate through all subredditLists cells
            for i in 0...(subredditsList.count - 1) {
                for j in 0...(subredditsList[i].redditPosts.count - 1) {
                    // Update the color scheme of the self.tableViewCell to that of the source.tableViewCell
                    let redditCell = redditPostsTableView.cellForRow(at: IndexPath(row: j, section: i))
                    redditCell?.backgroundColor = cell?.backgroundColor
                    redditCell?.textLabel?.textColor = cell?.textLabel?.textColor
                    redditCell?.detailTextLabel?.textColor = cell?.textLabel?.textColor
                }
            }
            
            // Build UserDefaults.standard data using the colors
            UserDefaults.standard.setColor(color: redditPostsTableView.backgroundColor!, forKey: "tableViewColor")
            UserDefaults.standard.setColor(color: (cell?.backgroundColor)!, forKey: "tableCellColor")
            UserDefaults.standard.setColor(color: (cell?.textLabel?.textColor)!, forKey: "tableTextColor")
        }
    }
    
    // Unwind method when "Save" button is pressed in SubredditsViewController
    @IBAction func unwindFromSubredditsSave(_ segue: UIStoryboardSegue) {
        if let source = segue.source as? SubredditsViewController {
            // Set the self.subredditsList to that of the source.subredditsList
            subredditsList = source.subreddits
            
            // Update the tableView to add new data
            redditPostsTableView.reloadData()
            
            // Create a default JSONEncoder
            let jsonEncoder = JSONEncoder()
            do {
                // Try to encode the subredditsList
                let jsonData = try jsonEncoder.encode(subredditsList)
                // Set the encoded subredditsList as a UserDefaults.standard
                UserDefaults.standard.set(jsonData, forKey: "subredditsList")
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

