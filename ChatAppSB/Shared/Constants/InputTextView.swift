//
//  InputTextView.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 25.12.2024.
//

import Foundation
import UIKit

class InputTextView: UITextView{
    
    let placeHolderLabel = CustomLabel(text: "  Type a message...", labelColor: .lightGray)
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
        isScrollEnabled = false
        font = .systemFont(ofSize: 15)
        
        addSubview(placeHolderLabel)
        placeHolderLabel.centerY(inView: self, leftAnchor: leftAnchor, rightAnchor:  rightAnchor, paddingLeft: 8)

        NotificationCenter.default.addObserver(self, selector: #selector(inputTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
        paddingView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func inputTextDidChange() {
        placeHolderLabel.isHidden = !text.isEmpty
    }
    
}

extension UITextView {
    
    func paddingView() {
        self.textContainerInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
    }
}
