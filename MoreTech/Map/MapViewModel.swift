//
//  LocationManagerViewModel.swift
//  MoreTechSwiftUI
//
//  Created by Danila Semischastnov on 13.10.2023.
//

import Foundation
import CoreLocation

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationManager = CLLocationManager()
    
    func askForPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            locationManager.requestAlwaysAuthorization()
        default:
            break
        }
    }
    
    static let locations: [Location] = [
        Location(
            capacity: 10,
            latitude: 56.184479,
            longitude: 36.984314
        ),
        Location(
            capacity: 20,
            latitude: 56.183239,
            longitude: 36.9757
        ),
        Location(
            capacity: 30,
            latitude: 56.012386,
            longitude: 37.482059
        ),
        Location(
            capacity: 40,
            latitude: 56.011509,
            longitude: 38.377728
        ),
        Location(
            capacity: 60,
            latitude: 56.008335,
            longitude: 37.851467
        ),
        Location(
            capacity: 80,
            latitude: 56.000401,
            longitude: 37.208775
        )
    ]
    
    struct Location: Hashable {
        let capacity: Int // from 0 to 100
        let latitude: CLLocationDegrees
        let longitude: CLLocationDegrees
    }
}
