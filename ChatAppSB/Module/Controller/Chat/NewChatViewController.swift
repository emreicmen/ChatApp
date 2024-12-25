//
//  NewChatViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 25.12.2024.
//

import UIKit

class NewChatViewController: UIViewController {
    
    //MARK: - Properties
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    //MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .green
        title = "Search"
    }
}

