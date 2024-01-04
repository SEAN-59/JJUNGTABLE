//
//  MyPageViewController.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/27/23.
//

import UIKit
//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//#Preview(traits: .portrait, body: {
//    MyPageViewController()
//})

class MyPageViewController: BaseVC {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: TopView!
    @IBOutlet weak var bottomView: BottomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        self.topView.delegate    = self
        self.bottomView.delegate = self
        
        self.topView.changeBtnHidden()
        self.topView.toggleCircleHidden()
    }
    
    override func tapFirstBtn() {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
extension MyPageViewController: UIScrollViewDelegate {}
