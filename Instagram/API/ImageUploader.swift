//
//  ImageUploader.swift
//  Instagram
//
//  Created by Hải Chu on 15/07/2021.
//

import UIKit
import FirebaseStorage
import Firebase

struct ImageUploader {
    
    static let storage = Storage.storage()
    
    static func uploadAvatar(image: UIImage, completion: @escaping(String) -> Void) {
        guard let image = image.jpegData(compressionQuality: 0.8) else {return}
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        let ref = storage.reference(withPath: "avatar/\(currentUid)")
        
        ref.putData(image, metadata: nil) { metadata, error in
            if let error = error {
                print("DEBUG: error while uploading avatar: \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, error in
                guard let url = url else {return}
                completion(url.absoluteString)
            }
        }
    }
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let image = image.jpegData(compressionQuality: 0.8) else {return}
        let filename = NSUUID().uuidString
        let ref = storage.reference(withPath: "post/\(filename)")
        
        ref.putData(image, metadata: nil) { metadata, error in
            if let error = error {
                print("DEBUG: error while uploading image: \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, error in
                guard let url = url else {return}
                completion(url.absoluteString)
            }
        }
    }
}
