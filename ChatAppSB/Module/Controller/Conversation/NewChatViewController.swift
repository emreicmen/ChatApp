//
//  NewChatViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 25.12.2024.
//

import UIKit

class NewChatViewController: UIViewController {
    
    //MARK: - Properties
    private let newChatTableView = UITableView()
    private let reuseIdentifier = "UserCell"
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
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
}

extension NewChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newChatTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        return cell
    }
    
    
    
}
