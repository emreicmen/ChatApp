//
//  ProfileViewModel.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 2.01.2025.
//

import Foundation

enum ProfileFields: Int, CaseIterable {
    case fullName
    case userName
    case email
    
    var description: String {
        switch self {
        case .fullName:
            return "Full Name"
        case .userName:
            return "User Name"
        case .email:
            return "E-mail"
        }
    }
}

struct ProfileViewModel {
    
    let user: User
    let fields: ProfileFields
    var filedTitle: String { return fields.description}
    
    var optionType: String? {
        switch fields {
        case .fullName:
            return user.fullName
        case .userName:
            return user.userName
        case .email:
            return user.email
        }
    }
  
    init(user: User, fields: ProfileFields) {
        self.user = user
        self.fields = fields
    }
    
    
}
