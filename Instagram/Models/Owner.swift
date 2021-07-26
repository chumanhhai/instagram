//
//  Owner.swift
//  Instagram
//
//  Created by Hải Chu on 23/07/2021.
//

import Foundation

struct Owner {
    let uid: String
    let imageUrl: String
    let nickname: String
    
    init(dict: [String: String]) {
        self.uid = dict["uid"]!
        self.imageUrl = dict["imageUrl"]!
        self.nickname = dict["nickname"]!
    }
}
