//
//  ExtensionChatController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 28.12.2024.
//

import UIKit
import AVFoundation

class MockCameraSession {
    static func generateMockVideoURL() -> URL? {
        
        if let videoData = NSDataAsset(name: "mockVideo")?.data {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("mockVideo.mp4")
            do {
                try videoData.write(to: tempURL)
                print("Temp file created: \(tempURL)")
                return tempURL
            } catch {
                print("Temp file couldn't create: \(error.localizedDescription)")
                return nil
            }
        } else {
            print("Mock video couldn't find.")
            return nil
        }
    }
}

extension ChatViewController {
    
    func openCamera() {
        #if targetEnvironment(simulator)
        print("Mock video using on simulator.")
        if let mockVideoURL = MockCameraSession.generateMockVideoURL() {
            print("Mock video URL founded: \(mockVideoURL)")
            self.uploadVideo(withVideoURL: mockVideoURL)
        }
        #else
        // Real device. CAmera will open
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = ["public.image", "public.movie"]
            present(imagePicker, animated: true)
        } else {
            print("Camera not exist.")
        }
        #endif
    }



    
    func openGallery() {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        present(imagePicker, animated: true)
    }
}

extension ChatViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true) {
            guard let mediaType = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaType.rawValue)] as? String else { return }
            
            if mediaType == "public.image" {
                guard let image = info[.editedImage] as? UIImage else { return }
                self.uploadImage(withImage: image)
            } else {
                guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
                self.uploadVideo(withVideoURL: videoURL)
            }
        }
    }
}

extension ChatViewController {
    
    func uploadImage(withImage image: UIImage) {
        showProgressBar(true)
        FileUploader.uploadImage(image: image) { imageURL in
            MessageServices.fetchSingleRecentMessage(otherUser: self.otherUser) { unReadMessageCount in
                MessageServices.uploadMessages(imageURL: imageURL, currentUser: self.currentUser, otherUser: self.otherUser, unReadCount: unReadMessageCount) { error in
                    self.showProgressBar(false)
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return
                    }
                }
            }
        }
    }
    
    func uploadVideo(withVideoURL url: URL) {
        showProgressBar(true)
        FileUploader.uploadVideo(url: url) { videoURL in
            MessageServices.fetchSingleRecentMessage(otherUser: self.otherUser) { unReadMessageCount in
                MessageServices.uploadMessages(videoURL: videoURL, currentUser: self.currentUser, otherUser: self.otherUser, unReadCount: unReadMessageCount) { error in
                    self.showProgressBar(false)
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return
                    }
                }
            }
        } failure: { error in
            print("Error: \(error.localizedDescription)")
            return
        }
    }
}
