//
//  CommonAlertViewController.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 11/1/23.
//

import UIKit
import SnapKit

class CommonAlertViewController: BaseVC {
    weak var coordinator: CommonAlertCoordinator?
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .backColor
        return view
    }()
    
    private lazy var backBtn = makeButton(tint: .clear)
    
    private var contentView: UIView = .init()
    
    private var alertType: AlertType = .bottom
    private var isAnimate: Bool = false
    private var layoutStruct: LayoutStruct = .init(top: 0, bottom: 0, leading: 0, trailing: 0)
    private var isKeyboard: Bool = true
    
    func setUpAlertVC(_ content: UIView, animate: Bool, type: AlertType, layout: LayoutStruct? = nil, isKeyBoard: Bool = true) {
        self.contentView = content
        self.alertType = type
        self.isAnimate = animate
        self.isKeyboard = isKeyBoard
        if let layout = layout {
            self.layoutStruct = layout
        } else {
            switch type {
            case .top:
                break
            case .center:
                self.layoutStruct.leading = 40
                self.layoutStruct.trailing = 40
            case .bottom:
                break
            }
        }
    }
    
    deinit {
        printFunc()
        self.coordinator?.popVC()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
    }
    
    private func setLayout(){
        self.backBtn.addTarget(self, action: #selector(tappedBtn(_:)), for: .touchUpInside)
        [
            self.backView,
            self.backBtn,
            self.contentView
        ].forEach { self.view.addSubview($0)}
        self.backView.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
        self.backBtn.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
//        
        switch alertType {
        case .top:
            break
        case .center:
            self.contentView.snp.updateConstraints {
                $0.center.equalToSuperview()
                $0.leading.equalToSuperview().inset(self.layoutStruct.leading)
                $0.trailing.equalToSuperview().inset(self.layoutStruct.trailing)
            }
        case .bottom:
            self.contentView.snp.updateConstraints {
                $0.leading.equalToSuperview().inset(self.layoutStruct.leading)
                $0.trailing.equalToSuperview().inset(self.layoutStruct.trailing)
            }
            self.view.keyboardLayoutGuide.topAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        }
        
    }
    
//    @IBAction func tapBackBtn(_ sender: UICustomButton) {
    @objc func tappedBtn(_ sender: UICustomButton) {
        self.view.endEditing(isKeyboard)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(isKeyboard)
    }
    

}
