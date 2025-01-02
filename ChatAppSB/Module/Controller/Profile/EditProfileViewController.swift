//
//  EditProfileViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 2.01.2025.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    //MARK: - Properties
    private let user: User
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = MAIN_COLOR
        button.setDimensions(height: 50, width: 200)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
        
    }()
    
    
    
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
    
    
    
    //MARK: - Helpers nad functions
    private func configureUI() {
        view.backgroundColor = .white
        
        title = "Edit Profile"
        
        view.addSubview(saveButton)
        saveButton.centerX(inView: view)
        saveButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
        
    }
    
    @objc func save() {
        print("save clicked")
    }
}

