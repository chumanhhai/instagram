//
//  RegisterService.swift
//  Instagram
//
//  Created by Hải Chu on 15/07/2021.
//

import UIKit
import Firebase

struct Credential {
    var name: String
    var email: String
    var password: String
    var image: UIImage
    var nickname: String
}

struct AuthenService {
    
    static func login(email: String, password: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authData, error in
            if let error = error { // if error
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    static func register(credential: Credential, completion: @escaping(Error?) -> Void) {
        Auth.auth().createUser(withEmail: credential.email, password: credential.password) { auth, error in
            guard let auth = auth else {
                completion(error)
                return
            }
            ImageUploader.uploadAvatar(image: credential.image) { url in
                let uid = auth.user.uid
                let user: [String: Any] = ["email": credential.email,
                                            "name": credential.name,
                                            "nickname": credential.nickname.lowercased(),
                                            "uid": uid,
                                            "imageUrl": url]
                Firestore.firestore().collection("users").document(uid).setData(user) { error in
                    completion(error)
                }
            }
        }
    }
}
