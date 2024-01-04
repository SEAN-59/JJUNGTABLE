//
//  BaseView.swift
//  SimpleNote
//
//  Created by Sean Kim on 9/29/23.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadNib()
    }
    
    private func loadNib() {
        let identifier = String(describing: type(of: self))
        let nibs = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
        guard let nibView = nibs?.first as? UIView else {return}
        nibView.frame = self.bounds
        self.addSubview(nibView)
        
        self.viewLoad()
    }
    
    func viewLoad() {
        
    }
}

extension BaseView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
}
