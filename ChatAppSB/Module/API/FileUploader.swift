//
//  FileUploader.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 23.12.2024.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

struct FileUploader {
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let uid = Auth.auth().currentUser?.uid ?? "/profileImages/"
        
        let fileName = NSUUID().uuidString
        let reference = Storage.storage().reference(withPath: "/\(uid)/\(fileName)")
        
        reference.putData(imageData, metadata: nil) { metadata, error in
            
            if let error = error {
                print("File Uploader error: \(error.localizedDescription)")
                return
            }
            
            reference.downloadURL { url, error in
                if let error = error {
                    print("File Uploader download error: \(error.localizedDescription)")
                    return
                }
                
                guard let fileUrl = url?.absoluteString else { return }
                
                completion(fileUrl)
            }
        }
    }
    
}
