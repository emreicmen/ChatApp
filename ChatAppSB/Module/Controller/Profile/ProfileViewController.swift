//
//  ProfileViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 2.01.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    

    
    //MARK: - Properties
    private let user: User
    private let profileImageView = CustomImageView(backgroundColor: .lightGray, cornerRadius: 20)
    
    
    
    //MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    

    
    //MARK: - Helpers and functions
    private func configureUI() {
        title = "My Profile"
        view.backgroundColor = .white
        
        view.addSubview(profileImageView)
        profileImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30)
        profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1).isActive = true
    }

}
