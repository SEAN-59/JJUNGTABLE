//
//  ReserveMapView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 12/29/23.
//

import UIKit
import SnapKit

class ReserveMapView: BaseView {
    static let identifier = "ReserveMapView"
    weak var delegate: ViewDelegate?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchAddressView: SearchAddressView!
    
    override func viewLoad() {
        self.searchAddressView.delegate = self
        
        self.contentView.layer.borderColor = UIColor.brandColor.cgColor
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.cornerRadius = 20.0
        
        self.searchAddressView.drawMap(corner: 20, mask: CACornerMask(arrayLiteral: .layerMinXMaxYCorner,.layerMaxXMaxYCorner), color: nil, width: 0)
        
        self.searchAddressView.snp.updateConstraints {
            $0.height.equalTo(getDeviceHeight()/2)
        }
        
    }
    
    @IBAction func tapSearchAddressBtn(_ sender: UICustomButton) {
        //        self.delegate?.sendViewData(text)
        
        //        APICall().geocordingAPI(query: "\(text)") { result in
        //            self.mapView.setAddressMap(addr: result)
        //        }
        
    }
    
    @IBAction func tapCloseBtn(_ sender: UICustomButton) {
        self.delegate?.tapCloseBtn()
    }
    
}
extension ReserveMapView: ViewDelegate {
    func sendViewData(identifier: String, data: Any) {
        if identifier == SearchAddressView.identifier {
            if data is String {
                self.delegate?.sendViewData(identifier: ReserveMapView.identifier, data: data)
            }
        }
        self.delegate?.tapCloseBtn()
        
        printLog("HERE is ReserveMapView: \(data)")
    }
}
