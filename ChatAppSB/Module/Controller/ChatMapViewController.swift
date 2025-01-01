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
    private var location: CLLocationCoordinate2D?
    private lazy var marker = GMSMarker()
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureMapView()
    }
    
    
    
    //MARK: - Helpers and Functions
    private func configureUI() {
        title = "Select location"
        view.backgroundColor = .white
        view.addSubview(mapView)
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    private func configureMapView() {
        FLocationManager.shared.start { info in
            self.location = CLLocationCoordinate2DMake(info.latitude ?? 0.0 , info.longitude ?? 0.0)
            self.mapView.delegate = self
            self.mapView.isMyLocationEnabled = true
            self.mapView.settings.myLocationButton = true
            
            guard let location = self.location else { return }
            self.updateCamera(location: location)
            
            FLocationManager.shared.stop()
        }
    }
    
    func updateCamera(location: CLLocationCoordinate2D) {
        self.location = location
        self.mapView.camera = GMSCameraPosition(target: location, zoom: 15)
        self.mapView.animate(toLocation: location)
        
        marker.map = nil
        marker = GMSMarker(position: location)
        marker.map = mapView
    }
}

extension ChatMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        updateCamera(location: coordinate)
    }
}
