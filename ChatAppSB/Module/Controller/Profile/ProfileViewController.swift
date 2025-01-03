//
//  ProfileViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 2.01.2025.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    

    
    //MARK: - Properties
    private var user: User
    private let profileImageView = CustomImageView(backgroundColor: .lightGray, cornerRadius: 20)
    private let tableView = UITableView()
    private let reuseIdentifier = "ProfileCell"
    

    
    
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
        configureTableView()
        configureData()
        
    }
    

    
    //MARK: - Helpers and functions
    private func configureUI() {
        title = "My Profile"
        view.backgroundColor = .white
        
        view.addSubview(profileImageView)
        profileImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30)
        profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1).isActive = true
        
        view.addSubview(tableView)
        tableView.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom:  view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 25, paddingLeft: 10, paddingBottom: 25, paddingRight: 10)
        
        let editProfileButton = UIBarButtonItem(title: "Edit Profile", style: .plain, target: self, action: #selector(editProfile))
        editProfileButton.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = editProfileButton

        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile), name: .userProfile, object: nil)

    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 70
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func configureData() {
        tableView.reloadData()
        guard let imageURL = URL(string: user.profileImageURL) else { return }
        profileImageView.sd_setImage(with: imageURL)
        profileImageView.contentMode = .scaleAspectFill
    }
    
    @objc func editProfile() {
        let editProfileController = EditProfileViewController(user: user)
        navigationController?.pushViewController(editProfileController, animated: true)
    }
    
    @objc func updateProfile() {
        navigationController?.popViewController(animated: true)
        UserService.fetchUser (uid: user.uid){ user in
            self.user = user
            self.configureData()
        }

    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileFields.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        guard let field = ProfileFields(rawValue: indexPath.row) else { return cell}
        cell.profileViewModel = ProfileViewModel(user: user, fields: field)
        return cell
    }
    
    
}
