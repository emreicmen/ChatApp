//
//  Message.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 26.12.2024.
//

import Foundation
import Firebase
import FirebaseAuth

struct Message {
    
    let text: String
    let fromID: String
    let toID: String
    let timestamp: Timestamp
    let userName: String
    let fullName: String
    let profileImageURL: String
    var isFromCurrentUser: Bool
    var chatPartnerID: String { return isFromCurrentUser ? toID : fromID }
    let newMessage: Int
    let imageURL: String
    let videoURL: String
    
    init(dictionary: [String: Any]){
        
        self.text = dictionary["text"] as? String ?? ""
        self.fromID = dictionary["fromID"] as? String ?? ""
        self.toID = dictionary["toID"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = fromID == Auth.auth().currentUser?.uid
        self.newMessage = dictionary["newMessage"] as? Int ?? 0
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.videoURL = dictionary["videoURL"] as? String ?? ""
    }
   
}
