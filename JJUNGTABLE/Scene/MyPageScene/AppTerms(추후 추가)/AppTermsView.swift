//
//  AppTermsView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 12/11/23.
//

import UIKit

class AppTermsView: BaseView {
    @IBOutlet weak var backView: UIView!
    
    override func viewLoad() {
        self.backView.layer.cornerRadius = 25
        self.backView.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
    }
    
    @IBAction func tapTermsBtn(_ sender: UICustomButton) {
    }
    
    @IBAction func tapPersonalInfomationBtn(_ sender: UICustomButton) {
    }
}
