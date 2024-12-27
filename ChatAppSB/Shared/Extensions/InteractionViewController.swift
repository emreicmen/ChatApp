//
//  ViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 24.12.2024.
//

import UIKit
import JGProgressHUD
import SDWebImage

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
    
    func getImageFromGoogleProfile(withImageUrl imageUrl: URL, completion: @escaping(UIImage) -> Void) {
        
        SDWebImageManager.shared.loadImage(with: imageUrl, options: .continueInBackground, progress: nil) { image, data, error, cacheType, finished, url in
            if let error = error {
                self.showMessage(title: "Error", message: error.localizedDescription)
                return
            }
            
            guard let image = image else { return }
            completion(image)
        }
    }
    
    func stringValue(forDate date: Date) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        return dateFormatter.string(from: date)
        
    }
}
