//
//  Notification.swift
//  Instagram
//
//  Created by Hải Chu on 24/07/2021.
//

import Foundation

enum NotificationType: Int {
    case like
    case comment
    case follow
}

struct Notification {
    let uid: String
    let postImageUrl: String
    let postUid: String
    let makerUid: String
    let makerImageUrl: String
    let makerNickname: String
    let type: NotificationType
    let createdAt: Double
    
    init(dict: [String: Any]) {
        uid = dict["uid"] as? String ?? ""
        postImageUrl = dict["postImageUrl"] as? String ?? ""
        postUid = dict["postUid"] as? String ?? ""
        makerUid = dict["makerUid"] as? String ?? ""
        makerImageUrl = dict["makerImageUrl"] as? String ?? ""
        makerNickname = dict["makerNickname"] as? String ?? ""
        type = NotificationType(rawValue: dict["type"] as? Int ?? 0)!
        createdAt = Date().timeIntervalSince1970
    }
}
