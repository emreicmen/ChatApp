//
//  ViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 24.12.2024.
//

import UIKit
import JGProgressHUD

public extension UIViewController {
    
    static let progressHud = JGProgressHUD(style: .dark)
    
    func showProgressBar(_ show: Bool) {
        view.endEditing(true)
        
        if show {
            UIViewController.progressHud.show(in: view)
        } else {
            UIViewController.progressHud.dismiss()
        }
    }
    
    func showMessage(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
