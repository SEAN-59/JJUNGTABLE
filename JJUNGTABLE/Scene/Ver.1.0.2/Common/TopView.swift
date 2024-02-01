//
//  TopView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/29/23.
//

import UIKit
import SnapKit

class TopView: JT_BaseView {
    weak var delegate: topButtonDelegate?

    private lazy var logoBtn = makeButton(systemName: "j.square.on.square", size: 30 , pallete: [.jjungColor] ,animate: (T,F), tag: 0)
    private lazy var firstBtn = makeButton(systemName: "circle", size: 25 , tint: .black ,animate: (T,F), tag: 1)
    private lazy var secondBtn = makeButton(systemName: "person.badge.plus", size: 25 , tint: .black ,animate: (T,F), tag: 2)
    private lazy var thirdBtn = makeButton(systemName: "bell", size: 25 , tint: .black ,animate: (T,F), tag: 3)
    private lazy var fourthBtn = makeButton(systemName: "gearshape", size: 25 , tint: .black ,animate: (T,F), tag: 4)
    
    private lazy var firstCircle = makeImgView(systemName: "circle.fill",
                                                pallete: [.jjungColor,.jjungColor,.jjungColor], size: 10)
    private lazy var secondCircle = makeImgView(systemName: "circle.fill",
                                                pallete: [.jjungColor,.jjungColor,.jjungColor], size: 10)
    private lazy var thirdCircle = makeImgView(systemName: "circle.fill",
                                                pallete: [.jjungColor,.jjungColor,.jjungColor], size: 10)
    private lazy var fourthCircle = makeImgView(systemName: "circle.fill",
                                                pallete: [.jjungColor,.jjungColor,.jjungColor], size: 10)
    
    
    private lazy var firstBtnView: UIView = {
        let view = UIView()
        
        self.firstBtn.addTarget(self, action: #selector(tappedBtn(_:)), for: .touchUpInside)
        
        [
            self.firstBtn,
            self.firstCircle
        ].forEach { view.addSubview($0) }
        
        self.firstBtn.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
        self.firstCircle.snp.updateConstraints {
            $0.top.trailing.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var secondBtnView: UIView = {
        let view = UIView()
        
        self.secondBtn.addTarget(self, action: #selector(tappedBtn(_:)), for: .touchUpInside)
        
        [
            self.secondBtn,
            self.secondCircle
        ].forEach { view.addSubview($0) }
        
        self.secondBtn.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
        self.secondCircle.snp.updateConstraints {
            $0.top.trailing.equalToSuperview()
        }
        return view
    }()
    private lazy var thirdBtnView: UIView = {
        let view = UIView()
        
        
        self.thirdBtn.addTarget(self, action: #selector(tappedBtn(_:)), for: .touchUpInside)
        
        [
            self.thirdBtn,
            self.thirdCircle
        ].forEach { view.addSubview($0) }
        
        self.thirdBtn.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
        self.thirdCircle.snp.updateConstraints {
            $0.top.trailing.equalToSuperview()
        }
        return view
    }()
    private lazy var fourthBtnView: UIView = {
        let view = UIView()
        
        self.fourthBtn.addTarget(self, action: #selector(tappedBtn(_:)), for: .touchUpInside)
        
        [
            self.fourthBtn,
            self.fourthCircle
        ].forEach { view.addSubview($0) }
        
        self.fourthBtn.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
        self.fourthCircle.snp.updateConstraints {
            $0.top.trailing.equalToSuperview()
        }
        return view
    }()
    private lazy var stackView: UIStackView = {
        
            let stackView = UIStackView()
            
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 10
        [
            self.firstBtnView,
            self.secondBtnView,
            self.thirdBtnView,
            self.fourthBtnView
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()

    override func viewLoad() {
        [
            self.logoBtn,
            self.stackView
        ].forEach { self.addSubview($0) }
        
        self.logoBtn.snp.updateConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        self.stackView.snp.updateConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(self.logoBtn)
        }
    }
    
    func toggleCircleHidden(is1stHidden: Bool = T, is2ndHidden: Bool = T, is3rdHidden: Bool = T, is4thHidden: Bool = T) {
        self.firstCircle.isHidden = is1stHidden
        self.secondCircle.isHidden = is2ndHidden
        self.thirdCircle.isHidden = is3rdHidden
        self.fourthCircle.isHidden = is4thHidden
    }
    
    /// Default = title 보여주고 나머지는 감춤
    func changeBtnHidden(isTitleHidden: Bool = F ,is1stHidden: Bool = T, is2ndHidden: Bool = T, is3rdHidden: Bool = T, is4thHidden: Bool = T) {
        self.logoBtn.isHidden = isTitleHidden
        self.firstBtnView.isHidden = is1stHidden
        self.secondBtnView.isHidden = is2ndHidden
        self.thirdBtnView.isHidden = is3rdHidden
        self.fourthBtnView.isHidden = is4thHidden
    }
    func changeBtnImage(count: Int, systemName: String = "", name: String = "", pallete: [UIColor] = []) {
        let image = makeImage(systemName: systemName, name: name, size: 25, pallete: pallete)
        switch count {
        case 0:
            self.logoBtn.setImage(image, for: .normal)
        case 1:
            self.firstBtn.setImage(image, for: .normal)
        case 2:
            self.secondBtn.setImage(image, for: .normal)
        case 3:
            self.thirdBtn.setImage(image, for: .normal)
        case 4:
            self.fourthBtn.setImage(image, for: .normal)
        default:
            break
        }
        
    }
    @objc func tappedBtn(_ sender: UICustomButton) {
        switch sender.tag {
        case 0:
            self.delegate?.tapTopButton(.firstBtn)
        case 1:
            self.delegate?.tapTopButton(.secondBtn)
        case 2:
            self.delegate?.tapTopButton(.thirdBtn)
        case 3:
            self.delegate?.tapTopButton(.forthBtn)
        case 4:
            self.delegate?.tapTopButton(.fifthBtn)
        default:
            self.delegate?.tapTopButton(.error)
        }
    }
    
}

