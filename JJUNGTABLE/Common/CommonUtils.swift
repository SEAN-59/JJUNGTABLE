//
//  CommonUtils.swift
//  SomeFuncTest
//
//  Created by Sean Kim on 2023/08/28.
//

import UIKit
import CoreLocation


class CommonUtils: NSObject {
    // ---- 싱글턴 패턴 사용을 위한 기초 설정 ---- //
    static let shared = CommonUtils()
    private override init() {}
    // --- --- --- --- --- --- --- --- --- //
    
    weak var locationDelegate: LocationDelegate?
    private var locationManager  = CLLocationManager()
    
// MARK: - 변수 선언부

// MARK: - 관련
    
// MARK: - Location 관련
    public func toggleUpdatingLocation(_ toggle: Bool) {
        if toggle {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
//    func showRequestLocationServiceAlert() {
//        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
//        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
//            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
//                UIApplication.shared.open(appSetting)
//            }
//        }
//        let cancel = UIAlertAction(title: "취소", style: .default) { [weak self] _ in
//            async { await self?.reloadData() }
//        }
//        requestLocationServiceAlert.addAction(cancel)
//        requestLocationServiceAlert.addAction(goSetting)
//
//        present(requestLocationServiceAlert, animated: true)
//    }
    
    public func checkLocationPermission() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
} // CLASS END


// MARK: - LocationManagerDelegate
extension CommonUtils: CLLocationManagerDelegate {
    // didChangeAuthorization 동작이 iOS 14 밑은 여기서 하게 됨
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        printLog("[위치] iOS ~14 didChangeAuthorization")
        switch status {
        case .authorizedWhenInUse, .authorizedAlways, .authorized:
            printLog("[위치] 권한 허용")
            self.locationDelegate?.checkPermission(true)
            self.toggleUpdatingLocation(true)
        default:
            printLog("[위치] 권한 미허용 & 기타 오류")
            self.locationDelegate?.checkPermission(false)
            self.toggleUpdatingLocation(false)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        printLog("locationManagerDidChangeAuthorization") // 처음 불러 올 떄 요거 불려짐
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationDelegate?.checkPermission(true)
            default:
                self.locationDelegate?.checkPermission(false)
            }
        } else {
            guard CLLocationManager.locationServicesEnabled() else {
                printLog("[위치] 권한 미허용")
                self.locationDelegate?.checkPermission(false)
                self.toggleUpdatingLocation(false)
                return
            }
            
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                printLog("[위치] 권한 허용")
                self.locationDelegate?.checkPermission(true)
                self.toggleUpdatingLocation(true)
            default:
                printLog("[위치] 권한 미허용 & 기타 오류")
                self.locationDelegate?.checkPermission(false)
                self.toggleUpdatingLocation(false)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        printLog("didUpdateLocations") // 요건 값을 가져올 때 불려짐
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationDelegate?.checkPermission(true)
                if let location = locations.first{
                    self.locationDelegate?.getLocation(location)
                }
            default:
                self.locationDelegate?.checkPermission(false)
            }
        } else {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                printLog("[위치] 권한 허용")
                self.locationDelegate?.checkPermission(true)
                if let location = locations.first{
                    printLog("[위치] 정보 수신 성공")
                    self.locationDelegate?.getLocation(location)
                }
            default:
                printLog("[위치] 권한 미허용 & 기타 오류")
                self.locationDelegate?.checkPermission(false)
                
            }
        }
        // stop 작업을 해야 멈춤
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        printLog("didFailWithError")
        self.locationDelegate?.checkPermission(false)
    }
    
}
