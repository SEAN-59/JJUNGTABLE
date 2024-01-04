//
//  MapView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 12/20/23.
//

import UIKit
import SnapKit

import NMapsMap

class MapView: BaseView {
    private let locationManager = CLLocationManager()
    private var markers = [NMFMarker]()
    
    private lazy var naverMap: NMFMapView = {
        let map = NMFMapView(frame: frame)
        map.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return map
    }()
    
    private lazy var marker: NMFMarker = {
        let marker = NMFMarker()
        return marker
    }()
    
    override func viewLoad() {
        self.locationManager.delegate = self
        self.setMapLayout()
    }
    
    deinit {
        printLog("MapView_deinit")
        locationManager.stopUpdatingLocation()
    }
    
    private func setMapLayout() {
        self.addSubview(self.naverMap)
        self.naverMap.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MapView: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            printLog("위치권한 허용")
        default:
            printLog("위치권한 미허용")
        }
    }
}

extension MapView: NMFMapViewCameraDelegate, NMFMapViewTouchDelegate {
    
}
