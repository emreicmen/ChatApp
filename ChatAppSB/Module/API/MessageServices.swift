//
//  MessageServices.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 26.12.2024.
//

import Foundation
import Firebase
import FirebaseAuth

struct MessageServices {
    
    static func fetchMessages(otherUser: User, completion: @escaping([Message]) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var messages = [Message]()
        let query = collectionMessage.document(uid).collection(otherUser.uid).order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, _ in
            guard let documentChanges = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            messages.append(contentsOf: documentChanges.map({ Message(dictionary: $0.document.data())}))
            
            completion(messages)
        }
    }
    
    
    static func fetchRecentMessages(completion: @escaping([Message]) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = collectionMessage.document(uid).collection("recent-message").order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, _ in
            guard let documentChanges = snapshot?.documentChanges else { return }
            let messages = documentChanges.map({Message(dictionary: $0.document.data())})
            
            completion(messages)
        }
        
    }
    
        
    static func uploadMessages(message: String = "", imageURL: String = "", currentUser: User, otherUser: User, unReadCount: Int ,completion:((Error?) -> Void)? ) {
    
        let dataFrom: [String: Any] = [
            "text": message,
            "fromID": currentUser.uid,
            "toID": otherUser.uid,
            "timestamp": Timestamp(date: Date()),
            
            "userName": otherUser.userName,
            "fullName": otherUser.fullName,
            "profileImageURL": otherUser.profleImageURL,
            
            "newMessage": 0,
            "imageURL": imageURL
        ]
        
        let dataTo: [String: Any] = [
            "text": message,
            "fromID": currentUser.uid,
            "toID": otherUser.uid,
            "timestamp": Timestamp(date: Date()),
            
            "userName": currentUser.userName,
            "fullName": currentUser.fullName,
            "profileImageURL": currentUser.profleImageURL,
            
            "newMessage": unReadCount,
            "imageURL": imageURL
        ]
        
        collectionMessage.document(currentUser.uid).collection(otherUser.uid).addDocument(data: dataFrom) { _ in
            collectionMessage.document(otherUser.uid).collection(currentUser.uid).addDocument(data: dataTo, completion: completion)
            collectionMessage.document(currentUser.uid).collection("recent-message").document(otherUser.uid).setData(dataFrom)
            collectionMessage.document(otherUser.uid).collection("recent-message").document(currentUser.uid).setData(dataTo)
        }
    }
    
    static func fetchSingleRecentMessage(otherUser: User, completion: @escaping(Int) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        collectionMessage.document(otherUser.uid).collection("recent-message").document(uid).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else {
                completion(0)
                return
            }
            
            let message = Message(dictionary: data)
            completion(message.newMessage)
            
        }
    }
    
    static func markReadAllMessages(otherUser: User) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return}
        
        let dataUpdate: [String: Any] = [
            "newMessage": 0
        ]
        
        collectionMessage.document(uid).collection("recent-message").document(otherUser.uid).updateData(dataUpdate)
    }
}
