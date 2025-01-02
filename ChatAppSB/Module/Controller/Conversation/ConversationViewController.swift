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
    private var unReadCount: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                self.unReadMessageLabel.isHidden = self.unReadCount == 0
            }
        }
    }
    private let searchController = UISearchController(searchResultsController: nil)
    private var filterConversation: [Message] = []
    
    //MARK: - UI Elements
    private lazy var profileButton: UIButton =  {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.2.badge.gearshape"), for: .normal)
        button.backgroundColor = MAIN_COLOR
        button.tintColor = .white
        button.setDimensions(height: 50, width: 50)
        button.layer.cornerRadius = 50 / 2
        button.addTarget(self, action: #selector(goToProfileView), for: .touchUpInside)
        return button
    }()
    private let unReadMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "7"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.backgroundColor = MAIN_COLOR
        label.setDimensions(height: 20, width: 20)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()

    
    
    
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
        configureSearchController()

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
        print(user.fullName)
        // Custom title view with user name and unread message label
        let titleView = UIView()

        // Create a horizontal stack view
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .equalCentering

        let nameLabel = UILabel()
        nameLabel.text = user.fullName
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(unReadMessageLabel)

        titleView.addSubview(stackView)
        stackView.centerX(inView: titleView)
        stackView.centerY(inView: titleView)

        unReadMessageLabel.setDimensions(height: 20, width: 20)
        titleView.sizeToFit()
        navigationItem.titleView = titleView

        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let newConversationBarButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewChat))
        newConversationBarButton.tintColor = MAIN_COLOR
        logoutButton.tintColor = .red
        
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItem = newConversationBarButton

        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 15, paddingRight: 15)
        
        view.addSubview(profileButton)
        profileButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 10, paddingRight: 20)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile), name: .userProfile, object: nil)
    }
    
    


    
    private func fetchConversations() {
        MessageServices.fetchRecentMessages { [self] conversations in
            conversations.forEach { conversation in
                conversationDictionary[conversation.chatPartnerID] = conversation
            }
            
            self.conversations = Array(self.conversationDictionary.values).sorted(by: {
                $0.timestamp.dateValue() > $1.timestamp.dateValue()
            })
            
            // Unread message count
            unReadCount = 0
            conversations.forEach { message in
                unReadCount += message.newMessage
            }
            
            // Update badge count
            updateBadgeCount(to: unReadCount)
            
            // Update unread message label
            DispatchQueue.main.async {
                self.unReadMessageLabel.text = "\(self.unReadCount)"
            }
        }
    }
    
    private func openChat(currentUser: User, otherUser: User) {
        let chatViewController = ChatViewController(currentUser: currentUser, otherUser: otherUser)
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    private func configureSearchController() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }
    
    func updateBadgeCount(to count: Int) {
        // Set the badge count using UNUserNotificationCenter
        UNUserNotificationCenter.current().setBadgeCount(count) { error in
            if let error = error {
                print("Failed to update badge count: \(error.localizedDescription)")
            } else {
                print("Badge count updated to \(count)")
            }
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
    
    @objc func goToProfileView() {
        let controller = ProfileViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
        
    @objc func updateProfile() {
        UserService.fetchUser(uid: user.uid) { user in
            self.user = user
            self.title = user.fullName
        }
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
    }
    
}


//MARK: - Search Delegate
extension ConversationViewController : UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filterConversation = conversations.filter({ $0.userName.contains(searchText) || $0.fullName.lowercased().contains(searchText)})
        print(filterConversation)
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = ""
        searchBar.showsCancelButton = false
    }
    
    
}
