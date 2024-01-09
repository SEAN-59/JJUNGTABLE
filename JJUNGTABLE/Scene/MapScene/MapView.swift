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
    private var nowCoord: NMGLatLng = NMGLatLng(lat: 0.0, lng: 0.0)
    private var coordinate: Coordniate = .init(lat: 0.0, lng: 0.0)
    
    // 카메라 위치 지정
    private var cameraPosition = NMFCameraPosition()
    
    // 화면 좌표와 지도 좌표간 변환위해
    private var projection = NMFProjection()//self.naverMap.projection
    
    private lazy var naverMap: NMFMapView = {
        let map = NMFMapView(frame: frame)
        map.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return map
    }()
    
    private lazy var marker: NMFMarker = {
        let marker = NMFMarker()
        marker.width = CGFloat(NMF_MARKER_SIZE_AUTO)
        marker.height = CGFloat(NMF_MARKER_SIZE_AUTO)
        
        marker.isHideCollidedMarkers = true // 마커와 다른 마커가 겹쳐질 때 마커를 자동으로 숨기도록 하기
        
        marker.touchHandler = { (overlay) in
            printLog("TAPPED MARKER")
            return true
        }
        return marker
    }()
    
    override func viewLoad() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
        self.setMapLayout()
        self.cameraPosition = self.naverMap.cameraPosition
        
        self.projection = self.naverMap.projection
    }
    
    deinit {
        printLog("MapView_deinit")
        self.locationManager.stopUpdatingLocation()
    }
    
    /// Map 그림 그리기
    ///
    /// 4분면 방향
    ///
    /// layerMaxXMinYCorner :    1사분면
    /// layerMinXMinYCorner  :    2사분면
    /// layerMinXMaxYCorner :    3사분면
    /// layerMaxXMaxYCorner:    4사분면
    func drawMap(corner: CGFloat = 0,
                 mask: CACornerMask = CACornerMask(arrayLiteral:.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner),
                 color: UIColor? = nil, width: CGFloat = 0) {
        self.naverMap.layer.maskedCorners = mask
        self.naverMap.layer.cornerRadius = corner
        self.naverMap.layer.borderColor = color?.cgColor
        self.naverMap.layer.borderWidth = width
    }
    
    func setAddressMap(addr: NaverGeocode) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: Double(addr.addresses[0].lng)!, lng: Double(addr.addresses[0].lat)!))
        self.naverMap.moveCamera(cameraUpdate)
    }
    
    private func setMapLayout() {
        self.addSubview(self.naverMap)
        
        self.naverMap.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    /// changeToCoord()
    ///
    /// isFromPoint : 화면 좌표를 지도 좌표 형식으로 바꾸려면 이 변수를 T로
    ///
    /// 지도 좌표의 x = lat, y=lng 로 설정
    private func changeToCoord(coord: Coordniate, isFromPoint: Bool) -> Coordniate {
        var result = Coordniate(lat: 0.0, lng: 0.0)
        if isFromPoint {
            // 화면 좌표를 지도 좌표 형식으로
            let coordinate = self.projection.latlng(from: CGPoint(x: coord.lat, y: coord.lng))
            result.lat = coordinate.lat
            result.lng = coordinate.lng
        }
        else {
            let point = self.projection.point(from: NMGLatLng(lat: coord.lat,
                                                              lng: coord.lng))
            result.lat = point.x
            result.lng = point.y
        }
        
        return result
    }
    
}

extension MapView: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            printLog("위치권한 허용")
            self.locationManager.startUpdatingLocation()
        default:
            printLog("위치권한 미허용")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            printLog("""
                     NOW LOCATION
                            lat: \(location.coordinate.latitude)
                            lng: \(location.coordinate.longitude)
                     """)
//            printLog("NOW LOCATION: \(location.coordinate.longitude)")
            
            self.nowCoord = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            
//            printLog("check = \(self.changeToCoord(coord: .init(lat: self.nowCoord.lat, lng: self.nowCoord.lng), isFromPoint: F))")
            
            // 현재 위치로 이동
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: self.nowCoord.lat, lng: self.nowCoord.lng))
            self.naverMap.moveCamera(cameraUpdate)
            self.locationManager.stopUpdatingLocation()
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        printLog("[ERROR] did update Location")
    }
}

extension MapView: NMFMapViewCameraDelegate, NMFMapViewTouchDelegate {
    
}
