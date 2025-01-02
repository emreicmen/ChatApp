//
//  UserViewModel.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 26.12.2024.
//

import Foundation

struct UserViewModel {
    
    let user: User
    
    var fullName: String { return user.fullName }
    var userName: String { return user.userName }
    var profileImageView: URL? {
        return URL(string: user.profileImageURL)
    }
    
    init(user: User) {
        self.user = user
    }
    
    
}
