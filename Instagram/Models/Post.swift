//
//  Post.swift
//  Instagram
//
//  Created by Hải Chu on 21/07/2021.
//

import UIKit

struct Post {
    
    static var currentPosts: [Post]?
    
    let imageUrl: String
    var caption: String
    var likes: [String]
    let createdAt: Double
    let owner: Owner
    let uid: String
    
    init(dict: [String: Any]) {
        imageUrl = dict["imageUrl"] as! String
        caption = dict["caption"] as! String
        likes = dict["likes"] as! [String]
        createdAt = dict["createdAt"] as! Double
        uid = dict["uid"] as! String
        
        let ownerDict = dict["owner"] as! [String: String]
        owner = Owner(dict: ownerDict)
    }
    
    static func insertIntoCurrentPosts(newPost: Post) {
        self.currentPosts?.insert(newPost, at: 0)
        User.currentUser?.stats.posts += 1
    }
}


