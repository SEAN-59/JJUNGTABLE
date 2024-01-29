//
//  CalendarViewController.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/29/23.
//

import UIKit
import SnapKit

//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//#Preview(traits: .portrait, body: {
//    CalendarViewController()
//})

class CalendarViewController: BaseVC {
    weak var coordinator: CalendarCoordinator?
    
    @IBOutlet weak var bottomView: BottomView!
    //    private lazy var bottomView: BottomView = {
//        let view = BottomView()
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayout()
        self.bottomView.delegate = self
        
    }
    
    private func setLayout() {
//        [
//            self.bottomView
//        ].forEach { self.view.addSubview($0) }
//        
//        self.bottomView.snp.updateConstraints {
//            $0.leading.bottom.trailing.equalTo(self.view.safeAreaLayoutGuide)
//        }
    }

    override func moveToVC(type: VCType) {
        
        if type == .main {
            self.coordinator?.choiceVC(.main, isPop: T)
        }
        else if type == .map {
            
        }
        else if type == .history {
            
        }
        else if type == .mypage {
            
        }
    }
}
