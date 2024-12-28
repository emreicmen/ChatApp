//
//  UICollectionViewCell.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 23.12.2024.
//


import UIKit

class ChatCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let profileImageView = CustomImageView(image: #imageLiteral(resourceName: "Google_Contacts_logo copy"), width: 30, height: 30, backgroundColor: .lightGray, cornerRadius: 15)
    private let dateLabel = CustomLabel(text: "20/10/2024", labelFont: .systemFont(ofSize: 9), labelColor: .lightGray)
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    var bubbleRightAnchor: NSLayoutConstraint!
    var bubbleLeftAnchor: NSLayoutConstraint!
    
    var dateRightAnchor: NSLayoutConstraint!
    var dateLeftAnchor: NSLayoutConstraint!
    
    var messageViewModel: MessageViewModel? {
        didSet{
            configure()
        }
    }
    
    private let textView: UITextView = {
        let textField = UITextView()
        textField.backgroundColor = .clear
        textField.isEditable = false
        textField.isScrollEnabled = false // Sadece boyutlandırma, kaydırma yapma
        textField.font = .systemFont(ofSize: 15)
        textField.text = "sample text message"
        return textField
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: contentView.leftAnchor, bottom: contentView.bottomAnchor, paddingLeft: 10)
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.layer.masksToBounds = true
        bubbleContainer.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: contentView.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 12, paddingBottom: 5)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 5, paddingLeft: 12, paddingBottom: 5, paddingRight: 12)
        
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        bubbleLeftAnchor.isActive = false
        
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleRightAnchor.isActive = true
        
        addSubview(dateLabel)
        dateLeftAnchor = dateLabel.leftAnchor.constraint(equalTo: bubbleContainer.rightAnchor, constant: 12)
        dateLeftAnchor.isActive = false
        dateRightAnchor = dateLabel.rightAnchor.constraint(equalTo: bubbleContainer.leftAnchor, constant: -12)
        dateRightAnchor.isActive = false
        
        dateLabel.anchor(bottom: contentView.bottomAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configure() {

        guard let messageViewModel = messageViewModel else { return }
        bubbleContainer.backgroundColor = messageViewModel.messageBackgorunColor
        textView.text = messageViewModel.messageText
        textView.textColor = messageViewModel.messageColor
        
        bubbleRightAnchor.isActive = messageViewModel.rightAnchorActive
        dateRightAnchor.isActive = messageViewModel.rightAnchorActive
        
        bubbleLeftAnchor.isActive = messageViewModel.leftAnchorActive
        dateLeftAnchor.isActive = messageViewModel.leftAnchorActive
        
        profileImageView.sd_setImage(with: messageViewModel.profileImageURL)
        profileImageView.isHidden = messageViewModel.shouldHideProfileImage
        
        guard let timestampString = messageViewModel.timestampString else {return}
        dateLabel.text = timestampString
        
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        // TextView boyutunu içeriğe göre hesapla
        let size = textView.sizeThatFits(CGSize(width: targetSize.width - 24, height: CGFloat.greatestFiniteMagnitude)) // padding ve sınırları dikkate al
        return CGSize(width: targetSize.width, height: size.height + 20) // Alt ve üst padding ekle
    }
}
