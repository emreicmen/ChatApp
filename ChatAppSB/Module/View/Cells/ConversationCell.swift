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
    private let unReadMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "7"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.backgroundColor = MAIN_COLOR
        label.setDimensions(height: 20, width: 20)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    
    //MARK: - Lifecycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor)
        
        let stackView = UIStackView(arrangedSubviews: [fullName, recentMessage])
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.alignment = .leading
        
        addSubview(stackView)
        stackView.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 15)
        
        let stackDateAndUnReadMessageLabel = UIStackView(arrangedSubviews: [unReadMessageLabel, dateLabel])
        stackDateAndUnReadMessageLabel.axis = .vertical
        stackDateAndUnReadMessageLabel.spacing = 5
        stackDateAndUnReadMessageLabel.alignment = .trailing
        
        addSubview(stackDateAndUnReadMessageLabel)
        stackDateAndUnReadMessageLabel.centerY(inView: profileImageView)
        stackDateAndUnReadMessageLabel.anchor(right: rightAnchor, paddingRight: 15)
        
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
        self.unReadMessageLabel.text = "\(messageViewModel.unReadCount)"
        self.unReadMessageLabel.isHidden = messageViewModel.shouldHideUnReadLabel
    }

}
