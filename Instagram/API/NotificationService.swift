//
//  NotificationService.swift
//  Instagram
//
//  Created by Hải Chu on 24/07/2021.
//

import Foundation
import Firebase

struct NotificationService {
    
    static func uploadNotification(post: Post?, ownerUid: String, type: NotificationType) {
        guard let currentUser = User.currentUser else {return}
        if currentUser.uid == ownerUid {return}
        
        let now = Date().timeIntervalSince1970
        var data: [String: Any] = ["makerUid": currentUser.uid,
                                   "makerImageUrl": currentUser.imageUrl,
                                   "makerNickname": currentUser.nickname,
                                   "type": type.rawValue,
                                   "createdAt": now]
        let ref = Firestore.firestore().collection("notifications")
            .document(ownerUid)
            .collection("items")
        // check if notification type is like or comment
        if type == .follow { // follow
            ref.whereField("makerUid", isEqualTo: currentUser.uid)
                .whereField("type", isEqualTo: type.rawValue)
                .getDocuments { snapshots, error in
                    if error != nil {return}
                    guard let snapshots = snapshots else {return}
                    if snapshots.count != 0 { // notification already exist
                        let uid = snapshots.documents[0].documentID
                        ref.document(uid).updateData(["createdAt": now])
                    } else { // notification does not exist
                        ref.addDocument(data: data)
                    }
                }
        } else { // like or comment
            guard let post = post else {return}
            ref.whereField("type", isEqualTo: type.rawValue)
                .whereField("makerUid", isEqualTo: currentUser.uid)
                .whereField("postUid", isEqualTo: post.uid)
                .getDocuments { snapshots, error in
                    if error != nil {return}
                    guard let snapshots = snapshots else {return}
                    if snapshots.count != 0 { // notification already exist
                        let uid = snapshots.documents[0].documentID
                        ref.document(uid).updateData(["createdAt": now])
                    } else { // notification does not exist
                        data["postUid"] = post.uid
                        data["postImageUrl"] = post.imageUrl
                        ref.addDocument(data: data)
                    }
                }
        }
    }
    
    static func fetchNotification(completion: @escaping([Notification]?, Error?) -> Void) {
        guard let userUid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("notifications")
            .document(userUid)
            .collection("items")
            .limit(to: 20)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshots, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                let notifications = snapshots!.documents.map { doc -> Notification in
                    var data: [String: Any] = doc.data()
                    data["uid"] = doc.documentID
                    return Notification(dict: data)
                }
                completion(notifications, nil)
            }
    }
}
