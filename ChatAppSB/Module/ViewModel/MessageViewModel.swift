//
//  MessageViewModel.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 26.12.2024.
//

import Foundation
import UIKit

struct MessageViewModel {
    
    let message: Message
    var messageText: String { return message.text}
    var messageBackgorunColor: UIColor { return message.isFromCurrentUser ? MAIN_COLOR : .systemGray6 }
    var messageColor: UIColor { return message.isFromCurrentUser ? .white : .black }
    var rightAnchorActive: Bool { return message.isFromCurrentUser }
    var leftAnchorActive: Bool { return !message.isFromCurrentUser }
    var shouldHideProfileImage: Bool { return message.isFromCurrentUser}
    var profileImageURL: URL? { return URL(string: message.profileImageURL)}
    var timestampString: String? {
        let date = message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: date)
    }
    var fullName: String { return message.fullName }
    var userName: String { return message.userName }
    var unReadCount: Int { return message.newMessage }
    var shouldHideUnReadLabel: Bool { return message.newMessage == 0 }
    var imageURL: URL? { return URL(string: message.imageURL) }
    var isImageHide: Bool { return message.imageURL == "" }
    var isTextHide: Bool { return message.imageURL != "" }
    var videoURL: URL? { return URL(string: message.videoURL) }
    var isVideoHide: Bool { return message.videoURL == ""}
    
    init(message: Message) {
        self.message = message
    }
    
    
}
