//
//  BottomView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/26/23.
//

import UIKit
import SnapKit



//class BottomView: BaseView {
class BottomView: UIView {
    weak var delegate: bottomButtonDelegate?
    /*
    private lazy var homeBtnView: UIView = {
        let view = UIView()
        let button = makeButton(systemName: "house", size: 22 ,tint: .black)
        let label = makeLabel(text: "Home", font: font_NPS(.regular,10))
        
        button.imageView?.contentMode = .center
        
        button.tag = 0
        button.addTarget(self, action: #selector(tappedBtn(_:)), for: .touchUpInside)
        
        [button,label].forEach{ view.addSubview($0) }
        button.snp.updateConstraints { $0.edges.equalToSuperview() }
        label.snp.updateConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        return view
    }()
    
    private lazy var calendarBtnView: UIView = {
        let view = UIView()
        let button = makeButton(systemName: "calendar", tint: .black)
        let label = makeLabel(text: "Calendar", font: font_NPS(.regular,10))
        
        button.tag = 1
        button.addTarget(self, action: #selector(tappedBtn(_:)), for: .touchUpInside)
        [button,label].forEach{ view.addSubview($0) }
        button.snp.updateConstraints { $0.edges.equalToSuperview() }
        label.snp.updateConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        return view
    }()
    
    
    private lazy var mapBtnView: UIView = {
        let view = UIView()
        let button = makeButton(systemName: "map", tint: .black)
        let label = makeLabel(text: "Map", font: font_NPS(.regular,10))
        
        button.tag = 2
        button.addTarget(self, action: #selector(tappedBtn(_:)), for: .touchUpInside)
        [button,label].forEach{ view.addSubview($0) }
        button.snp.updateConstraints { $0.edges.equalToSuperview() }
        label.snp.updateConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        return view
    }()
    
    
    private lazy var historyBtnView: UIView = {
        let view = UIView()
        let button = makeButton(systemName: "clock", tint: .black)
        let label = makeLabel(text: "History", font: font_NPS(.regular,10))
        
        button.tag = 3
        button.addTarget(self, action: #selector(tappedBtn(_:)), for: .touchUpInside)
        [button,label].forEach{ view.addSubview($0) }
        button.snp.updateConstraints { $0.edges.equalToSuperview() }
        label.snp.updateConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        return view
    }()
    
    
    private lazy var myPageBtnView: UIView = {
        let view = UIView()
        let button = makeButton(systemName: "person", tint: .black)
        let label = makeLabel(text: "myPage", font: font_NPS(.regular,10))
        
        button.tag = 4
        button.addTarget(self, action: #selector(tappedBtn(_:)), for: .touchUpInside)
        [button,label].forEach{ view.addSubview($0) }
        button.snp.updateConstraints { $0.edges.equalToSuperview() }
        label.snp.updateConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
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
            self.homeBtnView,
            self.calendarBtnView,
            self.mapBtnView,
            self.historyBtnView,
            self.myPageBtnView
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
     */

    @IBOutlet weak var homeBtn: UICustomButton!
    @IBOutlet weak var calendarBtn: UICustomButton!
    @IBOutlet weak var mapBtn: UICustomButton!
    @IBOutlet weak var reportBtn: UICustomButton!
    @IBOutlet weak var myPageBtn: UICustomButton!
    
    
    /*
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.loadNib()
        self.viewLoad()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewLoad()
//        self.loadNib()
    }
    
    func viewLoad() {
        self.addSubview(self.stackView)
        self.stackView.snp.updateConstraints {
            $0.trailing.leading.equalToSuperview().inset(5)
            $0.top.bottom.equalToSuperview()
        }
    }
//    
    */
//    @objc func tappedBtn(_ sender: UIButton) {
    @objc func tapBottmBtn(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.delegate?.tapBottomButton(.homeBtn)
        case 1:
            self.delegate?.tapBottomButton(.calendarBtn)
        case 2:
            self.delegate?.tapBottomButton(.mapBtn)
        case 3:
            self.delegate?.tapBottomButton(.historyBtn)
        case 4:
            self.delegate?.tapBottomButton(.myPageBtn)
        default:
            self.delegate?.tapBottomButton(.error)
        }
    }
}
