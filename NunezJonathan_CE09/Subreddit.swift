//
//  Subreddit.swift
//  NunezJonathan_CE09
//
//  Created by Jonathan Nunez on 12/12/18.
//  Copyright © 2018 Jonathan Nunez. All rights reserved.
//

import Foundation

class Subreddit: Codable {
    // Stored properties
    let subreddit: String
    var redditPosts = [RedditPosts]()
    
    // Initializer
    init?(subreddit: String) {
        self.subreddit = subreddit
    }
}
