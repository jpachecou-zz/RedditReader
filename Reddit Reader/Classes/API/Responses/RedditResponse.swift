//
//  RedditResponse.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/21/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import Foundation
import ObjectMapper
import NSDate_TimeAgo
import Then

struct RedditResponse: Mappable, Then {

    var posts: [RedditPost] = []
    
    public init?(map: Map) {
    }

    public mutating func mapping(map: Map) {
        posts <- map["data.children"]
    }
}

struct RedditPost: Mappable, Then {
    
    var title = ""
    var thumbnail = ""
    var author = ""
    var numComments = 0
    var created: TimeInterval = 0
    var score = 0
    var subreddit = ""
    var url = ""
    var position = 0
    var selftext = ""
    
    var timeAgo: String {
        return NSDate(timeIntervalSince1970: created).timeAgo()
    }
    
    public init?(map: Map) {
    }
    
    public mutating func mapping(map: Map) {
        title <- map["data.title"]
        thumbnail <- map["data.thumbnail"]
        author <- map["data.author"]
        numComments <- map["data.num_comments"]
        created <- map["data.created"]
        score <- map["data.score"]
        subreddit <- map["data.subreddit"]
        url <- map["data.url"]
        selftext <- map["data.selftext_html"]
    }
}
