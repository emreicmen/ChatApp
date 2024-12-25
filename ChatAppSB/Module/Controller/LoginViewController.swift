//
//  LoginViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 20.12.2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Properties
    
    var viewModel = LoginViewModel()
    
    private let welcomeLabel = CustomLabel(text: "Welcome to ChatApp", labelFont: .boldSystemFont(ofSize: 30))
    private let profileImageView = CustomImageView(image: #imageLiteral(resourceName: "ChatAppSB"), width: 150, height: 150)
    private let emailTextField = CustomTextField(placeholder: "E-mail", keyboardType: .emailAddress)
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecure: true)
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.mainTypeButton(buttonText: "Login")
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.secondTypeButton(firstText: "Forget your Password?", secondText: "Click here!")
        button.addTarget(self, action: #selector(forgetPassword), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpButton: UIButton = { // İsmi düzeltildi
        let button = UIButton(type: .system)
        button.secondTypeButton(firstText: "Dont you have an account?", secondText: "Sign Up here!")
        button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        return button
    }()
    
    private let continueLabel = CustomLabel(text: "or contunie with Google", labelFont: .systemFont(ofSize: 13), labelColor: .systemGray2)
    
    private lazy var googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear // Arka planı şeffaf yapabilirsiniz
        button.setDimensions(height: 40, width: 40) // Düğme boyutunu ayarlayın
        button.layer.cornerRadius = 20 // Yuvarlak bir görünüm için yarıçapı düğme yüksekliğinin yarısı yapın

        // Sadece resim ekleme
        if let googleImage = UIImage(named: "google")?.withRenderingMode(.alwaysOriginal) {
            button.setImage(googleImage, for: .normal)
        }
        button.imageView?.contentMode = .scaleAspectFit // Resmi uygun şekilde ölçeklendir

        button.addTarget(self, action: #selector(loginWithGoogle), for: .touchUpInside)
        return button
    }()



    
    
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        configureForTextField()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        welcomeLabel.centerX(inView: view)
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: welcomeLabel.bottomAnchor, paddingTop: 13)
        profileImageView.centerX(inView: view)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, forgotPasswordButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingRight: 30)
        
        view.addSubview(loginButton)
        loginButton.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 150, paddingLeft: 100, paddingRight: 100)
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: loginButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 50, paddingRight: 50)
        
        view.addSubview(signUpButton)
        signUpButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        signUpButton.centerX(inView: view)
        
        view.addSubview(continueLabel)
        continueLabel.centerX(inView: view, topAnchor: passwordTextField.bottomAnchor, paddingTop: 20)
        
        view.addSubview(googleButton)
        googleButton.centerX(inView: view, topAnchor: continueLabel.bottomAnchor, paddingTop: 15)
    }
    
    
    
    //MARK: - Actions
    
    private func configureForTextField() {
        emailTextField.addTarget(self, action: #selector(handleTextViewChanged(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextViewChanged(sender:)), for: .editingChanged)
    }
    
    @objc func login() {
        
        guard let email = emailTextField.text?.lowercased() else { return }
        guard let password = passwordTextField.text else { return }
        
        showProgressBar(true)
        AuthServices.logIn(withEmail: email, withPassword: password) { result, error in
            if let error = error {
                self.showProgressBar(false)
                self.showMessage(title: "Error", message: error.localizedDescription)
                return
            }
            self.showProgressBar(false)
            print("Login successed")
            self.navigateToConversationViewController()
        }
    }
    
    @objc func forgetPassword() {
        print("Forget Password")
    }
    
    @objc func signUp() {
        let registerViewController = RegisterViewController()
        registerViewController.delegate = self
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @objc func loginWithGoogle() {
        print("google")
    }
    
    @objc func handleTextViewChanged(sender: UITextField) {
        sender == emailTextField ? (viewModel.email = sender.text): (viewModel.password = sender.text )
        updateForm()
    }
    
    private func updateForm(){
        loginButton.isEnabled = viewModel.formIsFalid
        loginButton.backgroundColor = viewModel.backgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }
    
    private func navigateToConversationViewController() {
        let conversationViewController = ConversationViewController()
        let navigationController = UINavigationController(rootViewController: conversationViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}

//MARK: - Register Delegate
extension LoginViewController: RegisterViewControllerDelegate {
    
    func didSuccessfullyCreatedAccount(_ registerViewController: RegisterViewController) {
        registerViewController.navigationController?.popViewController(animated: true)
        navigateToConversationViewController()
    }
}
