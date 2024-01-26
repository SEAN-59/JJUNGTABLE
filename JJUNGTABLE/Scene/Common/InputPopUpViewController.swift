//
//  InputPopUpViewController.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 1/15/24.
//

import UIKit

class InputPopUpViewController: BaseVC {
    static let identifier = "InputPopUpViewController"
    weak var delegate: BaseVCDelegate?
    
    private var key = ""
    private var limitCount = 0
    private var textData = ""
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var inputTxf: UITextField!
    @IBOutlet weak var okBtn: UICustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputTxf.delegate = self
        self.setLayout()
    }
    
    private func setLayout() {

        self.contentView.layer.borderColor = UIColor.brandColor.cgColor
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.cornerRadius = 20.0
        self.inputTxf.placeholder = "1~\(self.limitCount) 글자를 입력해주세요."
        self.okBtn.setTitle("나가기", for: .normal)
        self.okBtn.setTitleColor(.brandColor, for: .normal)
        self.inputTxf.text = self.textData
    }
    
    func setData(key: String, limitCount: Int, data: String) {
        self.key = key
        self.limitCount = limitCount > 0 ? limitCount : 1
        self.textData = data
        printLog(self.limitCount)
    }


    @IBAction func tapOkButton(_ sender: UICustomButton) {
        if getTextfieldValue(sender.title(for: .normal)) == "확인" {
            let text = getTextfieldValue(self.inputTxf.text)
            self.delegate?.sendVCData(identifier: InputPopUpViewController.identifier, data: ["key": self.key, "data": text])
            self.dismiss(animated: T)
        }
        else if getTextfieldValue(sender.title(for: .normal)) == "나가기" {
            self.delegate?.sendVCData(identifier: InputPopUpViewController.identifier, data: ["key": self.key, "data": ""])
            self.dismiss(animated: T)
        }
        
    }
    

}
extension InputPopUpViewController {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = getTextfieldValue(self.inputTxf.text)
        printLog(text)
        if text.count == 0 {
            self.okBtn.setTitle("나가기", for: .normal)
            self.okBtn.setTitleColor(.brandColor, for: .normal)
        }
        else{
            self.okBtn.setTitle("확인", for: .normal)
            self.okBtn.setTitleColor(.blue, for: .normal)
        }
        if text.count > self.limitCount + 1 {
            textField.text = "\(text.dropLast(1))"
        }
    }
    
}
