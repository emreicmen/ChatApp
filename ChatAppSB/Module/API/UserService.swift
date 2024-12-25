//
//  UserService.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 25.12.2024.
//

import Foundation
import Firebase

struct UserService {
    
    static func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        collectionUser.document(uid).getDocument{(snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
}