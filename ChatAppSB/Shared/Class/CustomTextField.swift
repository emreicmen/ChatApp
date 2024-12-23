//
//  CustomTextField.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 23.12.2024.
//

import UIKit

class CustomTextField: UITextField {
    
    init(
        placeholder: String,
        tintColor: UIColor = .black,
        backgroundColor: UIColor = .systemGray6,
        cornerRadius: CGFloat = 20,
        height: CGFloat? = 50,
        isSecure: Bool = false,
        textAlignment: NSTextAlignment = .center,
        keyboardType: UIKeyboardType = .default,
        clearButtonMode: UITextField.ViewMode = .whileEditing

    ) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.isSecureTextEntry = isSecure
        self.textAlignment = textAlignment
        self.clearButtonMode = clearButtonMode
        
        if let height = height {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
