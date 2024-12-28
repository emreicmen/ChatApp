//
//  ExtensionChatController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 28.12.2024.
//

import UIKit

extension ChatViewController{
    
    func openCamera(){
        
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = ["public.image"]
        present(imagePicker, animated: true)
    }
    
    func openGallery(){
        
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.mediaTypes = ["public.image"]
        present(imagePicker, animated: true)
    }
}

extension ChatViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true) {
            //
        }
    }
    
}
