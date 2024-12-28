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
            
            guard let mediaType = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaType.rawValue)] as? String else { return }
            
            if mediaType == "public.image" {
                guard let image = info[.editedImage] as? UIImage else { return }
                self.uploadImage(withImage: image)
            }
        }
    }
}

extension ChatViewController {
    
    func uploadImage(withImage image: UIImage) {
        FileUploader.uploadImage(image: image) { imageURL in
            MessageServices.fetchSingleRecentMessage(otherUser: self.otherUser) { unReadMessageCount in
                MessageServices.uploadMessages(imageURL: imageURL, currentUser: self.currentUser, otherUser: self.otherUser, unReadCount: unReadMessageCount) { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        
                        return
                    }
                }
            }
        }
    }
}
