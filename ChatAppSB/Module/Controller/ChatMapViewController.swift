//
//  ChatMapViewController.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 1.01.2025.
//

import Foundation
import GoogleMaps

class ChatMapViewController: UIViewController {
    
    //MARK: - Properties
    private let mapView = GMSMapView()
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers and Functions
    private func configureUI() {
        title = "Select location"
        view.backgroundColor = .lightGray
        view.addSubview(mapView)
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}
