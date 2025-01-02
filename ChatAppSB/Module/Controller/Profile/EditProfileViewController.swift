//
//  EditProfileViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 2.01.2025.
//

import UIKit

class EditProfileViewController: UIViewController{
    
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
    private let fullNameLabel = CustomLabel(text: "Full Name", labelColor: MAIN_COLOR)
    private let fullNameTextField = CustomTextField(placeholder: "Full Name", textAlignment: .left)
    private let userNameLabel = CustomLabel(text: "User Name", labelColor: MAIN_COLOR)
    private let userNameTextField = CustomTextField(placeholder: "User Name", textAlignment: .left)
    private lazy var profileImageView: CustomImageView = {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        let imageView = CustomImageView(backgroundColor: .lightGray, cornerRadius: 20)
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
        
        
    }()
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    var selectedImage: UIImage?
    
    
    
    
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
        configureData()
    }
    
    
    
    //MARK: - Helpers nad functions
    private func configureUI() {
        view.backgroundColor = .white
        
        title = "Edit Profile"
        
        view.addSubview(saveButton)
        saveButton.centerX(inView: view)
        saveButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
        
        view.addSubview(profileImageView)
        profileImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30)
        profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField, userNameLabel, userNameTextField])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        
        view.addSubview(stackView)
        stackView.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingRight: 30)
        fullNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1).isActive = true
        userNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1).isActive = true
        
    }
    
    private func configureData() {
        fullNameTextField.text = user.fullName
        userNameTextField.text = user.userName
        guard let imageURL = URL(string: user.profileImageURL) else { return }
        profileImageView.sd_setImage(with: imageURL)
        profileImageView.contentMode = .scaleAspectFill
    }
    
    @objc func save() {
        guard let fullName = fullNameTextField.text else { return }
        guard let userName = userNameTextField.text else { return }
        showProgressBar(true)
        if selectedImage == nil {
            //update data without image
            let params = [
                "fullName": fullName,
                "userName": userName,
            ]
            updateUser(params: params)

        }else {
            //Upload with image
            guard let selectedImage = selectedImage else { return }
            FileUploader.uploadImage(image: selectedImage) { imageURL in
                let params = [
                    "fullName": fullName,
                    "userName": userName,
                    "profileImageURL": imageURL
                ]
                self.updateUser(params: params)
            }
        }
    }
    
    private func updateUser(params: [String: Any]) {
        UserService.setNewUserData(data: params) { _ in
            self.showProgressBar(false)
        }
    }
    
    @objc func selectImage() {
        present(imagePicker, animated: true)
    }
}

//MARK: - Image picker
extension EditProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectedImage = image
        self.profileImageView.image = image
        
        dismiss(animated: true)
    }
}
