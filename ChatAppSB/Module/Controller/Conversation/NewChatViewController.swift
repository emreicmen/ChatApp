//
//  NewChatViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 25.12.2024.
//

import UIKit
import FirebaseAuth

protocol NewChatViewControllerDelegate: AnyObject {
    func controller(_ viewController:NewChatViewController, wantChatWithUser otherUser: User)
}

class NewChatViewController: UIViewController {

    
    //MARK: - Properties
    weak var newChatViewDelegate: NewChatViewControllerDelegate?
    private let newChatTableView = UITableView()
    private let reuseIdentifier = "UserCell"
    private var users: [User] = [] {
        didSet {
            self.newChatTableView.reloadData()
        }
    }
    private let searchController = UISearchController(searchResultsController: nil)
    private var filterUsers: [User] = []
    var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
        fetchUers()
        configureSearchController()
    }
    
    private func configureTableView() {
        
        newChatTableView.delegate = self
        newChatTableView.dataSource = self
        newChatTableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        newChatTableView.tableFooterView = UIView()
        newChatTableView.backgroundColor = .white
        newChatTableView.rowHeight = 60
    }
    
    
    //MARK: - Helpers
    private func configureUI() {
        
        view.backgroundColor = .white
        title = "Search"
        
        view.addSubview(newChatTableView)
        newChatTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 15, paddingRight: 15)
    }
    
    private func fetchUers() {
        
        showProgressBar(true)
        UserService.fetchUsers { users in
            self.showProgressBar(false)
            self.users = users
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let index = self.users.firstIndex(where: {$0.uid == uid}) else { return }
            self.users.remove(at: index)
            print(users)
        }
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
}

extension NewChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filterUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newChatTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        cell.userViewModel = UserViewModel(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        newChatViewDelegate?.controller(self, wantChatWithUser: user)
    }
    
    
}


//MARK: - Search Delegate
extension NewChatViewController : UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filterUsers = users.filter({ $0.userName.contains(searchText) || $0.fullName.lowercased().contains(searchText)})
        newChatTableView.reloadData()
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
