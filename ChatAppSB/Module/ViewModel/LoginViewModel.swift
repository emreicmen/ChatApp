//
//  LoginViewModel.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 20.12.2024.
//

import Foundation
import UIKit

protocol AuthLoginModel {
    var formIsFalid: Bool {get}
    var backgroundColor: UIColor {get}
    var buttonTitleColor: UIColor{get}
}

struct LoginViewModel: AuthLoginModel {
    
    var email: String?
    var password: String?
    
    var formIsFalid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var backgroundColor: UIColor {
        return formIsFalid ? (MAIN_COLOR): (UIColor.black.withAlphaComponent(0.5))
    }
    
    var buttonTitleColor: UIColor{
        return formIsFalid ? (UIColor.white): (UIColor(white: 1, alpha: 0.7))
    }
    
}

struct RegisterViewModel: AuthLoginModel {
    
    var email: String?
    var password: String?
    var fullName: String?
    var userName: String?
    
    var formIsFalid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullName?.isEmpty == false && userName?.isEmpty == false
    }
    
    var backgroundColor: UIColor {
        return formIsFalid ? (MAIN_COLOR): (UIColor.black.withAlphaComponent(0.5))
    }
    
    var buttonTitleColor: UIColor {
        return formIsFalid ? (UIColor.white): (UIColor(white: 1, alpha: 0.7))
    }    
    
}
