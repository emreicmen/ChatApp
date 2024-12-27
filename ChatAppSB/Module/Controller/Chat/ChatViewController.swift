//
//  ChatViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 25.12.2024.
//

import Foundation
import UIKit

class ChatViewController: UICollectionViewController {
    
    //MARK: - Properties
    private let reuseIdentifier = "ChatCell"
    private var messages = [[Message]]()
    private lazy var customInputView: CustomInputView = {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let inputView = CustomInputView(frame: frame)
        inputView.delegate = self
        return inputView
    }()
    private var currentUser: User
    private var otherUser: User

    
    
    //MARK: - Lifecycle
    init(currentUser: User, otherUser: User) {
        self.currentUser = currentUser
        self.otherUser = otherUser
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func markReadAllMessage() {
        MessageServices.markReadAllMessages(otherUser: otherUser)
    }
    
    
    
    
    //MARK: - Helpers
    private func configureUI() {
        
        title = otherUser.fullName
        collectionView.backgroundColor = .white
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
        }
    }
}



//MARK: - CollectionView
extension ChatViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        let message = messages[indexPath.section][indexPath.row]
        cell.messageViewModel = MessageViewModel(message: message)
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
}



//MARK: - CustomInputViewDelegate
extension ChatViewController: CustomInputViewDelegate {
    
    func inputView(_ view: CustomInputView, wantUploadMessage message: String) {
        
        MessageServices.fetchSingleRecentMessage(otherUser: otherUser) {[self] unReadCount in
            MessageServices.uploadMessages(message: message, currentUser: currentUser, otherUser: otherUser, unReadCount: (unReadCount + 1)) { _ in
                self.collectionView.reloadData()
            }
        }
        
        view.clearTextView()

    }
    
}
