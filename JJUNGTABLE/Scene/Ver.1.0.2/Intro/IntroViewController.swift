//
//  IntroViewController.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/28/23.
//

import UIKit
import SnapKit

class IntroViewController: BaseVC {
    weak var coordinator: IntroCoordniator?
    
    private lazy var logoImg: UIImageView = {
        let img = UIImageView()
        var configuration = UIImage.SymbolConfiguration(pointSize: 100,weight: .unspecified, scale: .large)
        configuration = .init(paletteColors: [.jjungColor, .jjungColor, .jjungColor])
        img.image = .init(systemName: "j.square.on.square", withConfiguration: configuration)
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var markLbl: UILabel = {
        let label = UILabel()
        let text: String = "© 2023. Sean.Kim"
        let attribute = NSMutableAttributedString(string: text)
        attribute.addAttribute(.font,
                               value: font_NPS(.regular, 12),
                               range: (text as NSString).range(of: text))
        attribute.addAttribute(.foregroundColor,
                               value: UIColor.lightGray,
                               range: (text as NSString).range(of: text))
        label.attributedText = attribute
        return label
    }()
    
    
    
    
    
// MARK: - END CREATE UI
    deinit {
        printLog("deinit")
        self.coordinator?.popVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printLog("viewDidLoad")
        self.setLayout()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printLog("viewDidAppear")
        // 탈옥 확인 부분
        if isIllegalDevice() {
            makeAlert(self, title: "경고", message: "변경된 OS('탈옥'등)의 스마트폰은 \n서비스를 이용할수 없습니다.",
                      actionTitle: ["종료"], style: [.destructive], handler: [ {_ in exit(1)} ])
        }
        else {
            ConnectData().connectVersion { [weak self] alert in
                guard let self = self else {return}
                self.showAlert(alert)
            }
        }
    }
    
    private func setLayout() {
        [
            self.logoImg,
            self.markLbl
        ].forEach { self.view.addSubview($0) }
        
        self.view.backgroundColor = .systemBackground
        
        self.logoImg.snp.updateConstraints {
            $0.width.height.equalTo(200)
            $0.centerX.centerY.equalToSuperview()
        }
        
        self.markLbl.snp.updateConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
    }
}
