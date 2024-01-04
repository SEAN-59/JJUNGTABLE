//
//  AppSupportView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 12/11/23.
//

import UIKit

class AppSupportView: BaseView {

    @IBOutlet weak var backView: UIView!
    override func viewLoad() {
        self.backView.layer.cornerRadius = 25
        self.backView.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
    }

    @IBAction func tapNoticeBtn(_ sender: UICustomButton) {
        
    }
    
    @IBAction func tapSendEmailBtn(_ sender: UICustomButton) {
        
    }
}
