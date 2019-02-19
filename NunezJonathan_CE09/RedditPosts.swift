//
//  RedditPosts.swift
//  NunezJonathan_CE09
//
//  Created by Jonathan Nunez on 12/12/18.
//  Copyright © 2018 Jonathan Nunez. All rights reserved.
//

import Foundation

class RedditPosts: Codable {
    // Stored properties
    let title: String
    let author: String
    var thumbnailString: String
    
    // Optional Initializer
    init?(jsonObject: [String: Any]) {
        // Parse through JSON object to get RedditPost object values
        guard let redditData = jsonObject["data"] as? [String: Any],
            let redditTitle = redditData["title"] as? String,
            let redditAuthor = redditData["author"] as? String,
            let hasThumbnail = redditData["thumbnail"] as? String
            else{return nil}
        
        self.title = redditTitle
        self.author = redditAuthor
        self.thumbnailString = hasThumbnail
    }
}
