//
//  UserCell.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 25.12.2024.
//

import UIKit

class UserCell: UITableViewCell {

    //MARK: - Properties
    var userViewModel: UserViewModel? {
        didSet {
            configure()
        }
    }
    private let profileImageView = CustomImageView(width: 50, height: 50, backgroundColor: .lightGray, cornerRadius: 25)
    private let userName = CustomLabel(text: "Bruce WAYNE", labelFont: .boldSystemFont(ofSize: 14))
    private let fullName = CustomLabel(text: "Bruce WAYNE", labelFont: .systemFont(ofSize: 9), labelColor: .lightGray)
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor)
        
        let stackView = UIStackView(arrangedSubviews: [userName, fullName])
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.alignment = .leading
        
        addSubview(stackView)
        stackView.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 10)
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    
    private func configure() {
        guard let userViewModel = userViewModel else { return }
        self.fullName.text = userViewModel.fullName
        self.userName.text = userViewModel.userName
        self.profileImageView.sd_setImage(with: userViewModel.profileImageView)
    }

}
