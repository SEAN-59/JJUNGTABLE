//
//  MyInfoView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 11/9/23.
//

import UIKit

class MyInfoView: BaseView {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    
    override func viewLoad() {
        
        self.profileImg.layer.cornerRadius = 10.0
        self.profileImg.layer.borderColor = UIColor.black.cgColor
        self.profileImg.backgroundColor = .backColor

    }
    
    func changeView(_ name: String, _ state: String?) {
        self.nameLbl.text = "\(name)"
        if let state = state, state != "" {
            self.stateLbl.textColor = .label
            self.stateLbl.text = "\(state)"
        }
        else {
            self.stateLbl.textColor = .lightGray
            self.stateLbl.text = "상태메세지 추가하기 +"
        }
    }
    
    @IBAction func tapStateBtn(_ sender: UICustomButton) {
        let nextVC = CommonAlertViewController(nibName: "CommonAlertViewController", bundle: nil)
        
        nextVC.setUpAlertVC(ChangeStateView(), animate: true, type: .bottom,isKeyBoard: false)
        viewControllers[viewControllers.count - 1].pushVC(nextVC: nextVC)
    }
    
    
    // 프로필 사진 변경하는 부분이 될건데 해당 부분을 어떻게 저장을 하고 관리를 할 것인지는 차차 알아가보도록 합시다.
    @IBAction func tapImageBtn(_ sender: UICustomButton) {
    }
}
