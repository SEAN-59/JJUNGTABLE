//
//  ReserveMapView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 12/29/23.
//

import UIKit
import SnapKit

class ReserveMapView: BaseView {
    weak var delegate: ViewDelegate?
    
    @IBOutlet weak var mapAddressTxf: UITextField!
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mapView: MapView!
    
    override func viewLoad() {
        self.mapAddressTxf.delegate = self
        
        self.contentView.layer.borderColor = UIColor.brandColor?.cgColor
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.cornerRadius = 20.0
        self.mapView.drawMap(corner: 20, mask: CACornerMask(arrayLiteral: .layerMinXMaxYCorner,.layerMaxXMaxYCorner), color: nil, width: 0)
        self.mapView.snp.updateConstraints {
            $0.height.equalTo(getDeviceHeight()/2)
        }
    }
    
    @IBAction func tapSearchAddressBtn(_ sender: UICustomButton) {
        let text = getTextfieldValue(self.mapAddressTxf.text)
        self.delegate?.sendViewData(text)
        
        APICall().geocordingAPI(query: "\(text)") { result in
            self.mapView.setAddressMap(addr: result)
        }
        
    }
    
    @IBAction func tapCloseBtn(_ sender: UICustomButton) {
        self.delegate?.tapCloseBtn()
    }
    
}

extension ReserveMapView {
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.mapAddressTxf
        self.endEditing(T)
    }
}
