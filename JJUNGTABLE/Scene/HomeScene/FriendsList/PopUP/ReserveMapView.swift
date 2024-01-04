//
//  ReserveMapView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 12/29/23.
//

import UIKit

class ReserveMapView: BaseView {
    weak var delegate: ViewDelegate?
    
    @IBOutlet weak var mapAddressTxf: UITextField!
    
    override func viewLoad() {
        
    }
    
    @IBAction func tapSearchAddressBtn(_ sender: UICustomButton) {
        let text = getTextfieldValue(self.mapAddressTxf.text)
        self.delegate?.sendViewData(text)
        
    }
    
    @IBAction func tapCloseBtn(_ sender: UICustomButton) {
        self.delegate?.tapCloseBtn()
    }
    
}
