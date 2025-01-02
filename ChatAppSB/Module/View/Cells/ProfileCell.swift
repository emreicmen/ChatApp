//
//  ProfileCell.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 2.01.2025.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    //MARK: - Properties
    private let titleLabel = CustomLabel(text: "Name", labelColor: MAIN_COLOR)
    private let userNameLabel = CustomLabel(text: "Username")
    var profileViewModel: ProfileViewModel? {
        didSet {
            configure()
        }
    }
    
    
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, userNameLabel])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        
        addSubview(stackView)
        stackView.centerY(inView: self, leftAnchor:  leftAnchor, paddingLeft: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    //MARK: - Helpers and Functions
    private func configure() {
        guard let profileViewModel = profileViewModel else { return }
        titleLabel.text = profileViewModel.filedTitle
        userNameLabel.text = profileViewModel.optionType
        
    }
}
