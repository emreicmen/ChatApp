//
//  ChatHeader.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 27.12.2024.
//

import UIKit

class ChatHeader: UICollectionReusableView {
    
    var dateValue: String? {
        didSet{
            configure()
        }
    }
    
    private let dateLabel: CustomLabel = {
        
        let label = CustomLabel(text: "10/10/2024", labelFont: .systemFont(ofSize: 14), labelColor: .black)
        label.setDimensions(height: 20, width: 100)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.backgroundColor = .systemGray6
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dateLabel)
        dateLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        guard let dateValue = dateValue else {
            return
        }
        dateLabel.text = dateValue
    }
}
