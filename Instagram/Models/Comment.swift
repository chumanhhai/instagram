//
//  Comment.swift
//  Instagram
//
//  Created by Hải Chu on 23/07/2021.
//

import Foundation

struct Comment {
    let uid: String
    let postUid: String
    let createdAt: Double
    var content: String
    let owner: Owner
    
    init(dict: [String: Any]) {
        uid = dict["uid"] as! String
        postUid = dict["postUid"] as! String
        createdAt = dict["createdAt"] as! Double
        content = dict["content"] as! String
        
        let ownerDict = dict["owner"] as! [String: String]
        owner = Owner(dict: ownerDict)
    }
}
