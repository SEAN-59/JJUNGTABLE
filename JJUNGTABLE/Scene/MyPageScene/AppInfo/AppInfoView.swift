//
//  AppInfoView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 12/11/23.
//

import UIKit

class AppInfoView: BaseView {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var verTitleLbl: UILabel!
    @IBOutlet weak var updateBtn: UICustomButton!
    
    override func viewLoad() {
        @UserDefault(key: "currentVer", defaultValue: "") var currentVer
        @UserDefault(key: "finalVer", defaultValue: "") var finalVer
        
        self.backView.layer.cornerRadius = 25
        self.backView.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
        self.iconImg.layer.cornerRadius = 10
        
        self.verTitleLbl.text = "\(currentVer)"
        
        if currentVer == finalVer {
            self.updateBtn.setTitle("최신버전입니다", for: .normal)
        }
        else {
            self.updateBtn.setTitle("업데이트", for: .normal)
            self.updateBtn.layer.borderColor = UIColor.backColor
                .withAlphaComponent(0.5).cgColor
            self.updateBtn.setTitleColor(.backColor, for: .normal)
        }
    }

    @IBAction func tapGoToUpdateBtn(_ sender: UICustomButton) {
        
        @UserDefault(key: "currentVer", defaultValue: "") var currentVer
        @UserDefault(key: "finalVer", defaultValue: "") var finalVer
        if currentVer != finalVer {
            // 같은 경우에는 동작 안함
            makeAlert(viewControllers[viewControllers.count - 1],
                      title: "업데이트", message: "업데이트를 하시겠습니까?",
                      actionTitle: ["확인", "취소"],
                      style: [.cancel,.default],
                      handler: [
                        {_ in},
                        {_ in}
                      ]
            )
        }
    }
}
