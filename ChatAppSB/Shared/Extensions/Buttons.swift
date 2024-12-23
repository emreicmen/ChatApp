//
//  Buttons.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 20.12.2024.
//

import UIKit

extension UIButton {
    
    func attributedText(firstString: String, secondString: String){
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), .font: UIFont.systemFont(ofSize: 13)]
        let attrubutedTitle = NSMutableAttributedString(string: "\(firstString) ", attributes: atts)
        
        let secondAtts: [NSAttributedString.Key: Any] = [.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), .font: UIFont.systemFont(ofSize: 14)]
        attrubutedTitle.append(NSAttributedString(string: secondString, attributes: secondAtts))
        
        setAttributedTitle(attrubutedTitle, for: .normal)
    }
    
    func mainTypeButton(buttonText: String) {
        setTitle(buttonText, for: .normal)
        tintColor = .white
        backgroundColor = MAIN_COLOR
        setHeight(50)
        layer.cornerRadius = 10
        titleLabel?.font = .systemFont(ofSize: 18)
        isEnabled = false
    }
    
    func secondTypeButton(firstText: String, secondText: String) {        
        attributedText(firstString: firstText, secondString: secondText)
        tintColor = .systemGray
        setHeight(20)
        titleLabel?.font = .systemFont(ofSize: 13)
    }
}

