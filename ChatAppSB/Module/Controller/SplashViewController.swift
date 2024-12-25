//
//  SplashViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 25.12.2024.
//

import UIKit
import FirebaseAuth

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser?.uid == nil {
            let controller = LoginViewController()
            let navigationContoller = UINavigationController(rootViewController: controller)
            
            navigationContoller.modalPresentationStyle = .fullScreen
            present(navigationContoller, animated: true, completion: nil)
        }else {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            showProgressBar(true)
            UserService.fetchUser(uid: uid) { user in
                self.showProgressBar(false)
                let controller = ConversationViewController(user: user)
                let navigationContoller = UINavigationController(rootViewController: controller)
                navigationContoller.modalPresentationStyle = .fullScreen
                self.present(navigationContoller, animated: true, completion: nil)
            }
        }
    }
}
