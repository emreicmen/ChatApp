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
import AVKit

struct FileUploader {
    
    //MARK: - Upload Image
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
    
    //MARK: - Upload Video
    static func uploadVideo(url: URL, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputURL = documentsURL.appendingPathComponent(name)
        
        // Convert video formant nad upload to firebase
        DispatchQueue.global(qos: .utility).async {
            self.convertVideo(toMPEG4FormatForVideo: url, outputURL: outputURL) { session in
                if let sessionOutputURL = session.outputURL {
                    do {
                        let videoData = try Data(contentsOf: sessionOutputURL)
                        DispatchQueue.main.async {
                            uploadToFirebase(videoData: videoData, fileName: name, success: success, failure: failure)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            print("Video file couldn't read: \(error.localizedDescription)")
                            failure(error)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Error while converting video!.")
                        failure(NSError(domain: "FileUploader", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error while converting video!"]))
                    }
                }
            }
        }
    }
    
    private static func uploadToFirebase(videoData: Data, fileName: String, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        
        let storageRef = Storage.storage().reference().child("Videos").child(fileName)
        
        storageRef.putData(videoData, metadata: nil) { metadata, error in
            if let error = error {
                print("Video upload error: \(error.localizedDescription)")
                failure(error)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Download URL error: \(error.localizedDescription)")
                    failure(error)
                    return
                }
                
                guard let fileURL = url?.absoluteString else {
                    print("Download URL return empty.")
                    failure(NSError(domain: "FileUploader", code: -1, userInfo: [NSLocalizedDescriptionKey: "Download URL return empty."]))
                    return
                }
                
                print("Video file successfully uploaded.Video URL: \(fileURL)")
                success(fileURL)
            }
        }
    }

    static func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler: @escaping (AVAssetExportSession) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            let asset = AVURLAsset(url: inputURL)
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
                print("AVAssetExportSession couldn't created.")
                return
            }
            
            exportSession.outputURL = outputURL
            exportSession.outputFileType = .mp4
            exportSession.exportAsynchronously {
                DispatchQueue.main.async {
                    handler(exportSession)
                }
            }
        }
    }
    
    //MARK: - Upload Audio
    static func uploadAudio(audioURL: URL, completion: @escaping(String) -> Void) {
        
        let uid = Auth.auth().currentUser?.uid ?? "/profileImages/"
        let fileName = NSUUID().uuidString
        let reference = Storage.storage().reference(withPath: "/\(uid)/\(fileName)")
        reference.putFile(from: audioURL, metadata: nil) { metadata, error in
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
