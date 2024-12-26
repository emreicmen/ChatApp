//
//  MessageServices.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 26.12.2024.
//

import Foundation
import Firebase

struct MessageServices {
    
    static func fetchMessages() {
        
        
    }
    
    
    static func fetchRecentMessages() {
        
        
    }
    
        
    static func uploadMessages(message: String, currentUser: User, otherUser: User, completion:((Error?) -> Void)? ) {
    
        let dataFrom: [String: Any] = [
            "text": message,
            "fromID": currentUser.uid,
            "toID": otherUser.uid,
            "timestamp": Timestamp(date: Date()),
            
            "userName": otherUser.userName,
            "fullName": otherUser.fullName,
            "profileImageURL": otherUser.profleImageURL
        ]
        
        let dataTo: [String: Any] = [
            "text": message,
            "fromID": currentUser.uid,
            "toID": otherUser.uid,
            "timestamp": Timestamp(date: Date()),
            
            "userName": currentUser.userName,
            "fullName": currentUser.fullName,
            "profileImageURL": currentUser.profleImageURL
        ]
        
        collectionMessage.document(currentUser.uid).collection(otherUser.uid).addDocument(data: dataFrom) { _ in
            collectionMessage.document(otherUser.uid).collection(currentUser.uid).addDocument(data: dataTo, completion: completion)
            collectionMessage.document(currentUser.uid).collection("recent-message").document(otherUser.uid).setData(dataFrom)
            collectionMessage.document(otherUser.uid).collection("recent-message").document(currentUser.uid).setData(dataTo)
        }
    }
    
    
    
}
