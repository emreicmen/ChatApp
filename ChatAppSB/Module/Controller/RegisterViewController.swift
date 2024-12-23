//
//  RegisterViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 20.12.2024.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    
    //MARK: - Properities
    var viewModel = RegisterViewModel()
        
    private let welcomeLabel = CustomLabel(text: "Register to Chatapp", labelFont: .boldSystemFont(ofSize: 30), labelColor: .black)
    
    
    private lazy var profileImagButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.setDimensions(height: 150, width: 150)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(choseProfileImage), for: .touchUpInside)
        return button
    }()
    
    
    private let emailTextField = CustomTextField(placeholder: "E-mail", keyboardType: .emailAddress)
    private let fullNameTextField = CustomTextField(placeholder: "Full Name")
    private let userNameTextField = CustomTextField(placeholder: "User Name")
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecure: true)
    
    private lazy var registerButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.mainTypeButton(buttonText: "Register")
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        return button
    
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.secondTypeButton(firstText: "Already registered?", secondText: "Log In here!")
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        configureUI()
        configureTextField()

    }
    
    
    
    //MARK: - Helpers
    private func configureUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        welcomeLabel.centerX(inView: view)
        
        view.addSubview(profileImagButton)
        profileImagButton.anchor(top: welcomeLabel.bottomAnchor, paddingTop: 13)
        profileImagButton.centerX(inView: view)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullNameTextField, userNameTextField])
        stackView.axis = .vertical
        stackView.spacing = 15
        view.addSubview(stackView)
        stackView.anchor(top: profileImagButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingRight: 30)
        
        view.addSubview(registerButton)
        registerButton.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 100, paddingRight: 100)
        
        view.addSubview(signInButton)
        signInButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        signInButton.centerX(inView: view)
    }
    
    
    private func configureTextField() {
        emailTextField.addTarget(self, action: #selector(handleTextViewChanged(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextViewChanged(sender:)), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(handleTextViewChanged(sender:)), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(handleTextViewChanged(sender:)), for: .editingChanged)
    }
    @objc func register() {
        print("Register")
    }
    
    @objc func signIn() {
        navigationController?.popViewController(animated: true)
    }

    
    @objc func handleTextViewChanged(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }else if sender == passwordTextField {
            viewModel.password = sender.text
        }else if sender == fullNameTextField {
            viewModel.fullName = sender.text
        }else {
            viewModel.userName = sender.text
        }
        
        updateForm()
    }
    
    private func updateForm(){
        registerButton.isEnabled = viewModel.formIsFalid
        registerButton.backgroundColor = viewModel.backgroundColor
        registerButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }
    
    @objc func choseProfileImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true,completion: nil)
    }
    
    
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImagButton.layer.cornerRadius = profileImagButton.frame.width / 2
        profileImagButton.layer.masksToBounds = true
        profileImagButton.layer.borderWidth = 3
        profileImagButton.layer.borderColor = MAIN_COLOR.cgColor
        profileImagButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        print("Captured")
        dismiss(animated: true, completion: nil)
    }
}
