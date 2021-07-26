//
//  User.swift
//  Instagram
//
//  Created by Hải Chu on 15/07/2021.
//

import UIKit
import Firebase

struct User {
    
    static var currentUser: User?
    
    var uid: String
    var name: String
    var nickname: String
    var email: String
    var imageUrl: String
    var isFollowed: Bool = false
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    var stats = Stats()
    
    init(dict: [String: Any]) {
        uid = dict["uid"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        nickname = dict["nickname"] as? String ?? ""
        email = dict["email"] as? String ?? ""
        imageUrl = dict["imageUrl"] as? String ?? ""
    }
    
    func equal(another: User) -> Bool {
        return uid == another.uid && name == another.name && nickname == another.nickname && email == another.email &&
            imageUrl == another.imageUrl && isFollowed == another.isFollowed && isCurrentUser == another.isCurrentUser && stats.equal(another: another.stats)
    }
    
    static func fetchCurrentUserAndPosts(context: UIViewController?) {
        UserService.fetchCurrentUser { user, error in
            if let error = error, let context = context { // if error
                context.showAlert(error.localizedDescription)
                return
            }
            // if success
            self.currentUser = user!
            UserService.getStatics(uid: user!.uid) { stats, error in
                if let error = error, let context = context {
                    context.showAlert(error.localizedDescription)
                    return
                }
                self.currentUser!.stats = stats!
                PostService.fetchUserPosts(uid: self.currentUser!.uid) { posts, error in
                    if let error = error, let context = context { // if error
                        context.showAlert(error.localizedDescription)
                        return
                    }
                    Post.currentPosts = posts
                    self.currentUser!.stats.posts = posts!.count
                }
            }
        }
    }
}

struct Stats {
    var followers: Int
    var followings: Int
    var posts: Int
    
    init(posts: Int = 0, followers: Int = 0, followings: Int = 0) {
        self.followers = followers
        self.followings = followings
        self.posts = posts
    }
    
    func equal(another: Stats) -> Bool {
        return followers == another.followers && followings == another.followings
    }
}


