//
//  JT_BaseView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 2/1/24.
//

import UIKit

class JT_BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewLoad()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewLoad()
    }
    
    func viewLoad() {
        
    }
}

extension JT_BaseView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
}
