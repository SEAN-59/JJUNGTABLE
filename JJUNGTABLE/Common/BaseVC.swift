//
//  BaseVC.swift
//  SimpleNote
//
//  Created by Sean Kim on 9/29/23.
//

import UIKit

class BaseVC: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // 스와이프 뒤로가기 막기
//        naviController.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func tapFirstBtn() {}
    func tapSecondBtn() {}
    func tapThirdBtn() {}
    func tapForthBtn() {}
    func tapFifthBtn() {}
}

extension BaseVC: UITextFieldDelegate {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension BaseVC: bottomButtonDelegate, topButtonDelegate {
    
    // SEAN: 20231029 - 똑같은거 두번 눌렸을 경우에 변화 안하는거 넣어야 함
    func tapBottomButton(_ buttonType: BottomBtnType) {
        let nowVC = type(of: self)
        printLog("Click \(buttonType)")
        switch buttonType {
        case .homeBtn:
            if nowVC != type(of: MainViewController()) {
                popAndPushVC(nextVC: MainViewController(), popAnimate: false, pushAnimate: false)
            }
        case .calendarBtn:
            if nowVC != type(of: CalendarViewController()) {
                popAndPushVC(nextVC: CalendarViewController(), popAnimate: false, pushAnimate: false)
            }
        case .mapBtn:
            if nowVC != type(of: MapViewController()) {
                popAndPushVC(nextVC: MapViewController(), popAnimate: false, pushAnimate: false)
            }
        case .historyBtn:
            if nowVC != type(of: ReportViewController()) {
                popAndPushVC(nextVC: ReportViewController(), popAnimate: false, pushAnimate: false)
            }
        case .myPageBtn:
            if nowVC != type(of: MyPageViewController()) {
                popAndPushVC(nextVC: MyPageViewController(), popAnimate: false, pushAnimate: false)
            }
        case .error:
            break
        }
    }
    
    func tapTopButton(_ buttonType: TopBtnType) {
        printLog("Click \(buttonType)")
        switch buttonType {
        case .firstBtn:
            self.tapFirstBtn()
        case .secondBtn:
            self.tapSecondBtn()
        case .thirdBtn:
            self.tapThirdBtn()
        case .forthBtn:
            self.tapForthBtn()
        case .fifthBtn:
            self.tapFifthBtn()
            break
        case .error:
            break
        }
    }
    
}

//extension BaseVC: BaseVCDelegate {
//    func reloadVC() {}
//}
