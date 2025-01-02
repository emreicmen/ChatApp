//
//  AuthServices.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 23.12.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

struct AuthCredential {
    
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let profileImage: UIImage
}

struct AuthCredentialEmail {
    
    let email: String
    let uid: String
    let fullName: String
    let userName: String
    let profileImage: UIImage
}

struct AuthServices {
    
    static func logIn(withEmail email: String, withPassword password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }

    
    static func registerUser(credential: AuthCredential, completion: @escaping(Error?) -> Void) {
        
        FileUploader.uploadImage(image: credential.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credential.email, password: credential.password) { result, error in
                if let error = error {
                    print("Error while cretaing user(AuthServices): \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let data: [String: Any] = [
                    "email": credential.email,
                    "userName": credential.userName,
                    "fullName": credential.fullName,
                    "password": credential.password,
                    "uid": uid,
                    "profileImageURL": imageUrl
                ]
                
                collectionUser.document(uid).setData(data, completion: completion)
            }
            print("ImageUrl: \(imageUrl)")
        }
    }
    
    static func registerWithGoogle(credential: AuthCredentialEmail, completion: @escaping(Error?) -> Void) {
        
        FileUploader.uploadImage(image: credential.profileImage) { imageUrl in
            let data: [String: Any] = [
                "email": credential.email,
                "userName": credential.userName,
                "fullName": credential.fullName,
                "uid": credential.uid,
                "profileImageURL": imageUrl
            ]
            
            collectionUser.document(credential.uid).setData(data, completion: completion)

        }
    }
}
