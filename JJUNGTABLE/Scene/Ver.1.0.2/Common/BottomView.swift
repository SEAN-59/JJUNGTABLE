//
//  BottomView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/26/23.
//

import UIKit



class BottomView: BaseView{
    weak var delegate: bottomButtonDelegate?
    
    @IBOutlet weak var homeBtn: UICustomButton!
    @IBOutlet weak var calendarBtn: UICustomButton!
    @IBOutlet weak var mapBtn: UICustomButton!
    @IBOutlet weak var reportBtn: UICustomButton!
    @IBOutlet weak var myPageBtn: UICustomButton!
    
    
    @IBAction func tapBottmBtn(_ sender: UICustomButton) {
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
    
    override func viewLoad() {
        
    }

}
