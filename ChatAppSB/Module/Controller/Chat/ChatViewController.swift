//
//  ChatViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 25.12.2024.
//

import Foundation
import UIKit
import AVFoundation

class ChatViewController: UICollectionViewController {
    
    var audioPlayer: AVAudioPlayer? // Global audio player

    
    //MARK: - Properties
    private let reuseIdentifier = "ChatCell"
    private var messages = [[Message]]()
    private lazy var customInputView: CustomInputView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let inputView = CustomInputView(frame: frame)
        inputView.delegate = self
        
        return inputView
    }()
    var currentUser: User
    var otherUser: User
    private let chatHeaderIdentifier = "Chat Header"
    private lazy var attachAlert: UIAlertController = {
        let alert = UIAlertController(title: "Attach File", message: "Select file type to want to send", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Location", style: .default, handler: { _ in
            self.present(self.locationAlert, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        return alert
    }()
    private lazy var locationAlert: UIAlertController = {
        let alert = UIAlertController(title: "Share Location", message: "Select a type to want to share location", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Current Location", style: .default, handler: { _ in
            self.shareCurrentLocation()
        }))
        alert.addAction(UIAlertAction(title: "Google Map", style: .default, handler: { _ in
            self.shareGoogleMapsLocations()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return alert
    }()
    lazy var imagePicker: UIImagePickerController = {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        return picker
    }()
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    
    //MARK: - Lifecycle
    init(currentUser: User, otherUser: User) {
        self.currentUser = currentUser
        self.otherUser = otherUser
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ChatHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: chatHeaderIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchMessages()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.markReadAllMessage()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        markReadAllMessage()
    }
        

    
    
    
    //MARK: - Helpers and Functions
    private func configureUI() {
        title = "To \(otherUser.fullName)"
        collectionView.backgroundColor = .white
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
    }
    
    private func fetchMessages() {
        
        MessageServices.fetchMessages(otherUser: otherUser) { messages in

            let groupMessages = Dictionary(grouping: messages) { (element) -> String in
                let dateValue = element.timestamp.dateValue()
                let stringDateValue = self.stringValue(forDate: dateValue)
                return stringDateValue ?? ""
            }
            
            self.messages.removeAll()
            
            let sortedKeys = groupMessages.keys.sorted(by: { $0 < $1 })
            sortedKeys.forEach { key in
                let values = groupMessages[key]
                self.messages.append(values ?? [])
            }
            self.collectionView.reloadData()
            self.collectionView.scrollToLastItem()
        }
    }
    
    private func markReadAllMessage() {
        MessageServices.markReadAllMessages(otherUser: otherUser)
    }
    
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
}



//MARK: - CollectionView
extension ChatViewController {

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let firstMessage = messages[indexPath.section].first else { return UICollectionReusableView() }
            let dateValue = firstMessage.timestamp.dateValue()
            let stringValue = stringValue(forDate: dateValue)
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: chatHeaderIdentifier, for: indexPath) as! ChatHeader
            cell.dateValue = stringValue
            
            return cell
        }        
        return UICollectionReusableView()
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        let message = messages[indexPath.section][indexPath.row]
        cell.messageViewModel = MessageViewModel(message: message)
        cell.chatCellDelegate = self
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages[section].count
    }
}



//MARK: - Delegate Flow Layout
extension ChatViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .init(top: 15, left: 0, bottom: 15, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cell = ChatCell(frame: frame)
        let message = messages[indexPath.section][indexPath.row]
        cell.messageViewModel = MessageViewModel(message: message)
        cell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 50)
        let estimateSize = cell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimateSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 25)
    }
}



//MARK: - CustomInputViewDelegate
extension ChatViewController: CustomInputViewDelegate {
   
    func inputViewForAttachButton(_ view: CustomInputView) {
        present(attachAlert, animated: true)
    }
    
    func inputView(_ view: CustomInputView, wantUploadMessage message: String) {
        MessageServices.fetchSingleRecentMessage(otherUser: otherUser) {[self] unReadCount in
            MessageServices.uploadMessages(message: message, currentUser: currentUser, otherUser: otherUser, unReadCount: (unReadCount + 1)) { _ in
                self.collectionView.reloadData()
            }
        }
        view.clearTextView()
    }
    
    func inputViewForAudio(_ view: CustomInputView, audioURL: URL) {
        self.showProgressBar(true)
        FileUploader.uploadAudio(audioURL: audioURL) { audioString in
            MessageServices.fetchSingleRecentMessage(otherUser: self.otherUser) { unReadMessageCount in
                MessageServices.uploadMessages(audioURL: audioString ?? "", currentUser: self.currentUser, otherUser: self.otherUser, unReadCount: unReadMessageCount) { error in
                    self.showProgressBar(false)
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        return 
                    }
                }
            }
        }
    }
}



//MARK: - Location
extension ChatViewController {
    
    func shareCurrentLocation() {
        FLocationManager.shared.start { info in
            guard let latitutde = info.latitude else { return }
            guard let longitude = info.longitude else { return }
            
            self.uploadLocation(lat: "\(latitutde)", long: "\(longitude)")
        }
    }
    
    func shareGoogleMapsLocations() {
        
    }
}
