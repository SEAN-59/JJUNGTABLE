//
//  MapViewController.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/29/23.
//

import UIKit
import SnapKit

//
//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//#Preview(traits: .portrait, body: {
//    CalendarViewController()
//})

class MapViewController: BaseVC {
    @IBOutlet weak var topView: TopView!
    @IBOutlet weak var bottomView: BottomView!
    @IBOutlet weak var mapView: MapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomView.delegate = self
        self.topView.delegate = self
        self.setLayout()
    }
    
    private func setLayout() {
        self.topView.changeBtnHidden(isTitleHidden: F,
                                     is1stHidden: T,
                                     is2ndHidden: T,
                                     is3rdHidden: T,
                                     is4thHidden: T)
    }
}
