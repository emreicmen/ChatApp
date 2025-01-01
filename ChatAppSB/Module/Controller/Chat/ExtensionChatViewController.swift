//
//  ExtensionChatController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 28.12.2024.
//

import AVFoundation
import ImageSlideshow
import SDWebImage
import SwiftAudioPlayer
import UIKit

class MockCameraSession {
    static func generateMockVideoURL() -> URL? {

        if let videoData = NSDataAsset(name: "mockVideo")?.data {
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent("mockVideo.mp4")
            do {
                try videoData.write(to: tempURL)
                print("Temp file created: \(tempURL)")
                return tempURL
            } catch {
                print(
                    "Temp file couldn't create: \(error.localizedDescription)")
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

extension ChatViewController: UIImagePickerControllerDelegate
        & UINavigationControllerDelegate
{

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:
            Any]
    ) {
        dismiss(animated: true) {
            guard
                let mediaType = info[
                    UIImagePickerController.InfoKey(
                        rawValue: UIImagePickerController.InfoKey.mediaType
                            .rawValue)] as? String
            else { return }

            if mediaType == "public.image" {
                guard let image = info[.editedImage] as? UIImage else { return }
                self.uploadImage(withImage: image)
            } else {
                guard
                    let videoURL = info[
                        UIImagePickerController.InfoKey.mediaURL] as? URL
                else { return }
                self.uploadVideo(withVideoURL: videoURL)
            }
        }
    }
}

//MARK: - Upload Media
extension ChatViewController {

    func uploadImage(withImage image: UIImage) {
        showProgressBar(true)
        FileUploader.uploadImage(image: image) { imageURL in
            MessageServices.fetchSingleRecentMessage(otherUser: self.otherUser)
            { unReadMessageCount in
                MessageServices.uploadMessages(
                    imageURL: imageURL, currentUser: self.currentUser,
                    otherUser: self.otherUser,
                    unReadCount: unReadMessageCount + 1
                ) { error in
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
            MessageServices.fetchSingleRecentMessage(otherUser: self.otherUser)
            { unReadMessageCount in
                MessageServices.uploadMessages(
                    videoURL: videoURL, currentUser: self.currentUser,
                    otherUser: self.otherUser,
                    unReadCount: unReadMessageCount + 1
                ) { error in
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

//MARK: - Chat Delegate
extension ChatViewController: ChatCellDelegate {

    func cell(wantToShowImage cell: ChatCell, imageURL: URL?) {
        let slideShow = ImageSlideshow()
        guard let imageURL = imageURL else { return }
        SDWebImageManager.shared.loadImage(with: imageURL, progress: nil) {
            image, _, _, _, _, _ in

            guard let image = image else { return }
            slideShow.setImageInputs([ImageSource(image: image)])
            slideShow.delegate = self as? ImageSlideshowDelegate
            let controller = slideShow.presentFullScreenController(from: self)
            controller.slideshow.activityIndicator = DefaultActivityIndicator()

        }
    }
    
    func cell(wantToPlayVideo cell: ChatCell, videoURL: URL?) {
        guard let videoURL = videoURL else { return }
        let videoPlayerController = VideoPlayerViewController(
            videoURL: videoURL)
        navigationController?.pushViewController(
            videoPlayerController, animated: true)
    }
    
    func cell(wantToPlayAudio cell: ChatCell, audioURL: URL?, isPlay: Bool) {
        
        guard let audioURL = audioURL else {
            print("Undefined Audio URL")
            return
        }

        if isPlay {
            URLSession.shared.dataTask(with: audioURL) { _, response, error in
                if let error = error {
                    print("Audio file reaching error: \(error.localizedDescription)")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        SAPlayer.shared.startRemoteAudio(withRemoteUrl: audioURL)
                        SAPlayer.shared.play()

                        let _ = SAPlayer.Updates.PlayingStatus.subscribe { playingStatus in
                            print("Playing Status: \(playingStatus)")
                            if playingStatus == .ended {
                                cell.resetAudioSettings()
                            }
                        }
                        print("Playing: \(audioURL)")
                    }
                } else {
                    print("Error reaching audio file.Https status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                }
            }.resume()
        }
    }
    
    func cell(wantToOpenGoogleMap cell: ChatCell, locationURL: URL?) {
        
        guard let googleMapsURL = URL(string: "comgooglemaps://") else { return }
        guard let locationURL = locationURL else { return }
        
        if UIApplication.shared.canOpenURL(googleMapsURL) {
            //We have the app
            UIApplication.shared.open(locationURL)
        }else {
            //We dont have the app
            UIApplication.shared.open(locationURL, options: [:])
        }
    }

}

//MARK: - Locaiton
extension ChatViewController {
    
    func uploadLocation(lat: String, long: String) {
        
        let locationURL = "https://www.google.com/maps/dir/?api=1&destination=\(lat),\(long)"
        
        self.showProgressBar(true)
        MessageServices.fetchSingleRecentMessage(otherUser: otherUser) { unReadCount in
            MessageServices.uploadMessages(locationURL: locationURL, currentUser: self.currentUser, otherUser: self.otherUser, unReadCount: unReadCount + 1) { error in
                self.showProgressBar(false)
            
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
    
    func shareCurrentLocation() {
        FLocationManager.shared.start { info in
            guard let latitutde = info.latitude else { return }
            guard let longitude = info.longitude else { return }
            
            self.uploadLocation(lat: "\(latitutde)", long: "\(longitude)")
        }
    }
    
    func shareGoogleMapsLocations() {
        
        let controller = ChatMapViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
