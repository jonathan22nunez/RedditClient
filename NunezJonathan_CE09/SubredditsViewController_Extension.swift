//
//  SubredditsViewController_Extension.swift
//  NunezJonathan_CE09
//
//  Created by Jonathan Nunez on 12/13/18.
//  Copyright © 2018 Jonathan Nunez. All rights reserved.
//

import Foundation

extension SubredditsViewController {
    func ParseRemoteJSON(subredditString: String) {
        // Create URLSession default Configuration
        let config = URLSessionConfiguration.default
        
        // Create a URLSession
        let session = URLSession(configuration: config)
        
        if let url = URL(string: "https://www.reddit.com/r/\(subredditString)/.json") {
            // Create a task
            let task = session.dataTask(with: url) { (data, response, error) in
                
                // Return if error
                if error != nil {return}
                
                // Check the response, it's status code, and the data
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    let data = data
                    else{return}
                
                // Do - Catch to gather JSON data
                do {
                    // Convert data to a JSON object
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        guard let redditData = json["data"] as? [String: Any],
                            let redditChildren = redditData["children"] as? [Any]
                            else{return}
                        
                        let subredditObj = Subreddit(subreddit: subredditString)
                        
                        for thirdLevelItem in redditChildren {
                            guard let object = thirdLevelItem as? [String: Any]
                                else{continue}
                            
                            if let redditPost = RedditPosts(jsonObject: object) {
                                subredditObj?.redditPosts.append(redditPost)
                            }
                        }
                        
                        self.subreddits.append(subredditObj!)
                    }
                }
                catch {
                    print("error")
                }
                // Reload tableview as it cannot reload itself
                DispatchQueue.main.async {
                    self.subredditsTableView.reloadData()
                }
            }
            // Resume task
            task.resume()
        }
    }
}
