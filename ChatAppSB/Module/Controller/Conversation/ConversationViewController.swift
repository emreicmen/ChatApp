//
//  ConverstationViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 24.12.2024.
//

import UIKit
import FirebaseAuth

class ConversationViewController: UIViewController {
    
    //MARK: - Properties
    private var user: User
    private let tableView: UITableView = UITableView()
    private let reuseIdentifier = "ConversationCell"
    private var conversations: [Message] = []{
        didSet{
            tableView.reloadData()
        }
    }
    private var conversationDictionary = [String: Message]()
    
    
    
    //MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureUI()
        fetchConversations()
    }
    
    
    
    
    
    //MARK: - Helpers
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.backgroundColor = .white
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    private func configureUI() {
        title = user.fullName
        view.backgroundColor = .white
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let newConversationBarButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewChat))
        newConversationBarButton.tintColor = MAIN_COLOR
        logoutButton.tintColor = MAIN_COLOR
        
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItem = newConversationBarButton
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 15, paddingRight: 15)
    }
    
    private func fetchConversations() {
        MessageServices.fetchRecentMessages { conversations in
            conversations.forEach { conversation in
                self.conversationDictionary[conversation.chatPartnerID] = conversation
            }
            self.conversations = Array(self.conversationDictionary.values)
        }
    }
    
    @objc func logout() {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        }catch {
            print("Error when signout")
        }
    }
    
    @objc func createNewChat() {
        let controller = NewChatViewController()
        controller.newChatViewDelegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func openChat(currentUser: User, otherUser: User) {
        let chatViewController = ChatViewController(currentUser: currentUser, otherUser: otherUser)
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
}




//MARK: - TableView
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        let conversation = conversations[indexPath.row]
        cell.messageViewModel = MessageViewModel(message: conversation)
        return cell
    }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let conversation = conversations[indexPath.row]
        self.showProgressBar(true)
        UserService.fetchUser(uid: conversation.chatPartnerID) {[self] otherUser in
            showProgressBar(false)
            openChat(currentUser: user, otherUser: otherUser)
        }
    }
    
}



//MARK: - NewChatViewControllerDelegate
extension ConversationViewController: NewChatViewControllerDelegate {
    
    func controller(_ viewController: NewChatViewController, wantChatWithUser otherUser: User) {
        viewController.dismiss(animated: true, completion: nil)
        openChat(currentUser: user, otherUser: otherUser)
        print(otherUser.fullName)
    }
    
    
}
