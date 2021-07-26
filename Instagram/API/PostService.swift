//
//  PostService.swift
//  Instagram
//
//  Created by Hải Chu on 20/07/2021.
//

import UIKit
import Firebase

class PostService {
    static func uploadPost(image: UIImage, caption: String, completion: @escaping(Post?, Error?) -> Void) {
        guard let currentUser = User.currentUser else {return}
        ImageUploader.uploadImage(image: image) { imageUrl in
            let id = UUID().uuidString
            let owner: [String: String] = ["imageUrl": currentUser.imageUrl,
                                           "nickname": currentUser.nickname,
                                           "uid": currentUser.uid]
            var dict: [String: Any] = ["imageUrl": imageUrl,
                                       "caption": caption,
                                       "likes": [],
                                       "createdAt": Date().timeIntervalSince1970,
                                       "owner": owner]
            Firestore.firestore().collection("posts")
                .document(id)
                .setData(dict) { error in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    dict["uid"] = id
                    completion(Post(dict: dict), nil)
                }
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]?, Error?) -> Void) {
        Firestore.firestore().collection("posts")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshots, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                let posts: [Post] = snapshots!.documents.map { doc in
                    var data = doc.data()
                    data["uid"] = doc.documentID
                    return Post(dict: data)
                }
                completion(posts, nil)
            }
    }
    
    static func fetchUserPosts(uid: String, completion: @escaping([Post]?, Error?) -> Void) {
        Firestore.firestore().collection("posts")
            .order(by: "createdAt", descending: true)
            .whereField("owner.uid", isEqualTo: uid)
            .getDocuments { snapshots, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                let posts: [Post] = snapshots!.documents.map { doc in
                    var data = doc.data()
                    data["uid"] = doc.documentID
                    return Post(dict: data)
                }
                completion(posts, nil)
            }
    }
    
    static func fetchSinglePost(uid: String, completion: @escaping(Post?, Error?) -> Void) {
        Firestore.firestore().collection("posts")
            .document(uid)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                var dict: [String: Any] = snapshot!.data()!
                dict["uid"] = snapshot!.documentID
                completion(Post(dict: dict), nil)
            }
    }
    
    static func uploadComment(postUid: String, content: String, completion: @escaping(Comment?, Error?) -> Void) {
        guard let currentUser = User.currentUser else {return}
        let uid = UUID().uuidString
        let owner: [String: Any] = ["uid": currentUser.uid,
                                    "imageUrl": currentUser.imageUrl,
                                    "nickname": currentUser.nickname]
        var data: [String: Any] = ["postUid": postUid,
                                   "content": content,
                                   "createdAt": Date().timeIntervalSince1970,
                                   "owner": owner]
        Firestore.firestore().collection("comments")
            .document(uid)
            .setData(data, completion: { error in
                data["uid"] = uid
                completion(Comment(dict: data), nil)
            })
    }
    
    static func fetchComments(postUid: String, completion: @escaping([Comment]?, Error?) -> Void) {
        Firestore.firestore().collection("comments")
            .whereField("postUid", isEqualTo: postUid)
            .order(by: "createdAt", descending: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                let comments = snapshot?.documents.map({ snapshot -> Comment in
                    var dict: [String: Any] = snapshot.data()
                    dict["uid"] = snapshot.documentID
                    return Comment(dict: dict)
                })
                completion(comments, nil)
            }
    }
    
    static func addLike(postUid: String) {
        guard let currentUser = User.currentUser else {return}
        Firestore.firestore().collection("posts")
            .document(postUid)
            .updateData(["likes": FieldValue.arrayUnion([currentUser.uid])])
    }
    
    static func removeLike(postUid: String) {
        guard let currentUser = User.currentUser else {return}
        Firestore.firestore().collection("posts")
            .document(postUid)
            .updateData(["likes": FieldValue.arrayRemove([currentUser.uid])])
    }
}
