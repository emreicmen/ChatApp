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
    private var messages: [Message] = []
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
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    
    
    //MARK: - Helpers
    private func configureUI() {
        
        title = otherUser.fullName
        collectionView.backgroundColor = .white
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func fetchMessages() {
        
        MessageServices.fetchMessages(otherUser: otherUser) { messages in
            self.messages = messages
            print(messages)
        }
    }
}



//MARK: - CollectionView
extension ChatViewController {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messages.count
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
        cell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 50)
        let estimateSize = cell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimateSize.height)
    }
}



//MARK: - CustomInputViewDelegate
extension ChatViewController: CustomInputViewDelegate {
    
    func inputView(_ view: CustomInputView, wantUploadMessage message: String) {

        MessageServices.uploadMessages(message: message, currentUser: currentUser, otherUser: otherUser) { _ in
            //
        }

        collectionView.reloadData()
        view.clearTextView()
    }
    
}
