//
//  CalendarSituationView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 12/7/23.
//

import UIKit

class CalendarSituationView: BaseView {
    private var monthTitle = 0
    // possibleWeekday,impossibleWeekday,possibleHolyday, impossibleHolyday 순서
    private var dayList = [Int]()
    
    @IBOutlet weak var monthTitleLbl: UILabel!
    
    @IBOutlet weak var possibleWeekdayLbl: UILabel!
    @IBOutlet weak var impossibleWeekdayLbl: UILabel!
    
    @IBOutlet weak var possibleHolydayLbl: UILabel!
    @IBOutlet weak var impossibleHolydayLbl: UILabel!
    
    @IBOutlet weak var reserveBtn: UICustomButton!
    
    override func viewLoad() {
        self.reserveBtn.layer.borderColor = UIColor.black.cgColor
        self.reserveBtn.layer.borderWidth = 2
        self.reserveBtn.layer.cornerRadius = 25
    }
    
    func setData(_ month: Int, _ list: [Int]) {
        self.dayList = list
        self.monthTitle = month
        self.setLayOut()
    }
    
    private func setLayOut() {
        self.monthTitleLbl.text = "\(self.monthTitle)"
        self.possibleWeekdayLbl.text = "\(dayList[0])"
        self.impossibleWeekdayLbl.text = "\(dayList[1])"
        self.possibleHolydayLbl.text = "\(dayList[2])"
        self.impossibleHolydayLbl.text = "\(dayList[3])"
    }
    
    @IBAction func tapReserveBtn(_ sender: UICustomButton) {
    }
}
