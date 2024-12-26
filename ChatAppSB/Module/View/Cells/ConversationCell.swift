//
//  ConversationCell.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 25.12.2024.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    //MARK: - Properties
    private let profileImageView = CustomImageView(image:#imageLiteral(resourceName: "Google_Contacts_logo copy"), width: 60, height: 60, backgroundColor: .lightGray, cornerRadius: 30)
    private let fullName = CustomLabel(text: "Bruce WAYNE")
    private let recentMessage = CustomLabel(text: "Recent messages", labelFont: .systemFont(ofSize: 13), labelColor: .lightGray)
    private let dateLabel = CustomLabel(text: "20/10/2024", labelFont: .systemFont(ofSize: 10), labelColor: .lightGray)
    var messageViewModel: MessageViewModel? {
        didSet{
            configure()
        }
    }
    
    //MARK: - Lifecycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor)
        
        let stackView = UIStackView(arrangedSubviews:  [fullName, recentMessage])
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.alignment = .leading
        
        addSubview(stackView)
        stackView.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 15)
        
        addSubview(dateLabel)
        dateLabel.centerY(inView: self, rightAnchor: rightAnchor, paddingRight: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Helpers
    private func configure() {
        guard let messageViewModel = messageViewModel else { return }
        
        self.profileImageView.sd_setImage(with: messageViewModel.profileImageURL)
        self.fullName.text = messageViewModel.fullName
        self.recentMessage.text = messageViewModel.messageText
        self.dateLabel.text = messageViewModel.timestampString
    }

}
