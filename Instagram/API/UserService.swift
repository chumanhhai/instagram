//
//  UserService.swift
//  Instagram
//
//  Created by Hải Chu on 16/07/2021.
//

import Foundation
import Firebase

typealias completionWithErrorCare = (Error?) -> Void

struct UserService {
    static func fetchUser(uid: String, completion: @escaping(User?, Error?) -> Void) {
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                if let error = error { // if error
                    completion(nil, error)
                    return
                }
                // if success
                let dict = snapshot!.data()
                let user = User(dict: dict!)
                completion(user, nil)
            }
    }
    
    static func fetchCurrentUser(completion: @escaping(User?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        fetchUser(uid: uid, completion: completion)
    }
    
    static func fetchUsers(name: String, completion: @escaping([User]?, Error?) -> Void) {
        let cleanName = name.lowercased().trimmingCharacters(in: [" "])
        Firestore.firestore().collection("users")
            .whereField("nickname", isGreaterThanOrEqualTo: cleanName)
            .whereField("nickname", isLessThanOrEqualTo: cleanName + "{")
            .limit(to: 50)
            .getDocuments { snapshots, error in
                if let error = error { // if error
                    completion(nil, error)
                    return
                }
                // if success
                let users = snapshots!.documents.map { doc in
                    User(dict: doc.data())
                }
                completion(users, nil)
            }
    }
    
    static func follow(uid: String, completion: @escaping(completionWithErrorCare)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("followings")
            .document(currentUid)
            .collection("users-following")
            .document(uid)
            .setData([:]) { error in
                if let error = error {
                    completion(error)
                    return
                }
                Firestore.firestore().collection("followers")
                    .document(uid)
                    .collection("users-follower")
                    .document(currentUid)
                    .setData([:], completion: completion)
            }
    }
    
    static func unfollow(uid: String, completion: @escaping(completionWithErrorCare)) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("followings")
            .document(currentUid)
            .collection("users-following")
            .document(uid)
            .delete { error in
                if let error = error {
                    completion(error)
                    return
                }
                Firestore.firestore().collection("followers")
                    .document(uid)
                    .collection("users-follower")
                    .document(currentUid)
                    .delete(completion: completion)
            }
    }
    
    static func getStatics(uid: String, completion: @escaping(Stats?, Error?) -> Void) {
        Firestore.firestore().collection("followings")
            .document(uid)
            .collection("users-following")
            .getDocuments { snapshots, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                let followings = snapshots!.documents.count
                Firestore.firestore().collection("followers")
                    .document(uid)
                    .collection("users-follower")
                    .getDocuments { snapshots, error in
                        if let error = error {
                            completion(nil, error)
                            return
                        }
                        let followers = snapshots!.documents.count
                        let stats = Stats(followers: followers, followings: followings)
                        completion(stats, nil)
                    }
            }
    }
    
    static func checkFollowed(uid: String, completion: @escaping(Bool?, Error?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("followings")
            .document(currentUid)
            .collection("users-following")
            .document(uid)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                let isFollowed = snapshot?.exists
                completion(isFollowed, nil)
            }
    }
}
