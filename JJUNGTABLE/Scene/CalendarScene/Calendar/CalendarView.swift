//
//  CalendarView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 12/1/23.
//

import UIKit
import SnapKit

class CalendarView: BaseView {
    weak var delegate: CalendarViewDelegate?
    
    private var date = CalendarDay(T)
    
    private let monthTitle = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN",
                              "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    private var firstDayOfWeek = 0
    private var lastDayOfMonth = 0
    
    private var checkBtn: Bool = F
    private var isToggleCell: Bool = F
    private var isCellConnect: Bool = T // Cell 색상 바뀌는거 여러개 바뀌게 할 건지
    private var selectCell: IndexPath? // 선택되어있는 cell
    private var isBeforeToday: Bool = F
    
    private var reserveList = [RESERVE_LIST]()
    
    @IBOutlet weak var yearTitleLbl: UILabel!
    @IBOutlet weak var monthNumTitleLbl: UILabel!
    @IBOutlet weak var monthTitle1stLbl: UILabel!
    @IBOutlet weak var monthTitle2ndLbl: UILabel!
    @IBOutlet weak var monthTitle3rdLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextMonthBtn: UICustomButton!
    @IBOutlet weak var prevMonthBtn: UICustomButton!
    
    private let CalendarCollectionViewCellNib = UINib(nibName: "CalendarCollectionViewCell", bundle: nil)
    
    private let collectionLayout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    override func viewLoad() {
        self.setCollectionView()
        self.setLayout()
        self.checkFirstAndLast()
    }
    
    func setData(_ checkBtn: Bool, dict: [RESERVE_LIST], isToggleCell: Bool = F, isCellConnect: Bool = T, isBeforeToday: Bool = F) {
        // 가능한 리스트들만
        self.reserveList = dict
        
        // 이전 달로 이동 가능 여부
        self.checkBtn = checkBtn
        
        // 껐다 켰다 가능 여부
        self.isToggleCell = isToggleCell
        
        // 오늘 이전의 데이트들 전부 disable 시키는 것
        self.isBeforeToday = isBeforeToday
        
        if self.checkBtn { self.changeCheckBtn() }
        
        let height = collectionView.frame.height
        self.collectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(self.CalendarCollectionViewCellNib, forCellWithReuseIdentifier: "CalendarCollectionViewCell")
        
        self.collectionView.collectionViewLayout = self.collectionLayout
        
        self.collectionView.showsVerticalScrollIndicator = F
        self.collectionView.showsHorizontalScrollIndicator = F
        self.collectionView.translatesAutoresizingMaskIntoConstraints = F
        
        self.collectionView.snp.updateConstraints {
            $0.height.equalTo(((collectionView.frame.width/7)*6))
        }
    }
    
    private func setLayout() {
        self.yearTitleLbl.text = " \(self.date.year)"
        self.monthNumTitleLbl.text = "\(self.date.month)"
        
        let monthLetter = "\(self.monthTitle[self.date.month-1])".letter()
        self.monthTitle1stLbl.text = monthLetter[0]
        self.monthTitle2ndLbl.text = monthLetter[1]
        self.monthTitle3rdLbl.text = monthLetter[2]
    }
    
    private func checkFirstAndLast() {
        self.firstDayOfWeek = String.combineDate(year: self.date.year,
                                                 month: self.date.month,
                                                 day: 1).convertDate().1.dayOfWeek
        
        self.lastDayOfMonth = String.combineDate(year: self.date.year,
                                                 month: self.date.month,
                                                 day: self.date.day).convertDate().1.getLastDayOfMonth()
    }
    
    private func changeCheckBtn() {
        // 현재 월인 경우 이전 달로 가는거 막기 (남은 예전 기록을 알 필요가 없지)
        if self.date.month == Date().month && self.date.year == Date().year { self.prevMonthBtn.isEnabled = false }
        // 현재 년 + 2 정도 되었으면 다음 달로 가는거 막기 (23년인데 25년껄 볼 필요는 없지)
        else if self.date.year > Date().year + 1 { self.nextMonthBtn.isEnabled = false}
        else {
            self.prevMonthBtn.isEnabled = true
            self.nextMonthBtn.isEnabled = true
        }
    }
    
    // cell disable시킬것들 정해두는것
    private func checkDisableDay() -> [Int] {
        var result = [Int]()
        
        
        if let monthList = self.reserveList[0]["\(self.date.year)"] {
            if let dayList = monthList["\(self.date.month)"] {
                for i in dayList {
                    result.append(i.stringToInt())
                }
            }
        }
        
        if let monthList = self.reserveList[1]["\(self.date.year)"] {
            if let dayList = monthList["\(self.date.month)"] {
                for i in dayList {
                    result.append(i.stringToInt())
                }
            }
        }
        
        if self.isBeforeToday{
            if self.date.year == Date().year, 
                self.date.month == Date().month,
                self.date.day == Date().day {
                for i in 1 ..< self.date.day {
                    result.append(i)
                }
            }
        }
        
        
        return Array(Set(result))

    }
    
    
    

    @IBAction func tapMoveMonthBtn(_ sender: UICustomButton) {
        
        if sender.tag == CalendarBtn.prevMonth.rawValue {
            if self.date.month == 1 {
                self.date.year -= 1 //self.date.year + 1
                self.date.month = 12
            }
            else { self.date.month -= 1}
            
            if self.checkBtn { self.changeCheckBtn() }
            self.setLayout()
            self.checkFirstAndLast()
            self.collectionView.reloadData()
        }
        
        else if sender.tag == CalendarBtn.nextMonth.rawValue {
            if self.date.month == 12 {
                self.date.year += 1 //self.date.year + 1
                self.date.month = 1
            }
            else { self.date.month += 1 }
            if self.checkBtn { self.changeCheckBtn() }
            self.setLayout()
            self.checkFirstAndLast()
            self.collectionView.reloadData()
        }
        
        self.delegate?.moveMonth(self.date)
    }
    
}
extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 컬렉션 뷰 칸 갯수
        42
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        UICollectionViewCell()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as? CalendarCollectionViewCell else { return CalendarCollectionViewCell() }
        
        // cell 내부 함수 동작 순서
        // 1. setData()
        // 2. changeDisableCell()
        
        cell.delegate = self
        
        let list = self.checkDisableDay()
        
        var data = self.date
        data.day = -1
        
        if indexPath.row >= self.firstDayOfWeek &&
            indexPath.row < (self.firstDayOfWeek + self.lastDayOfMonth) {
            data.day = indexPath.row - self.firstDayOfWeek + 1
            data.dayOfWeek = String.combineDate(year: data.year,
                                               month: data.month,
                                               day: data.day).convertDate().1.dayOfWeek
        }
        
        if data.day == Date().day && data.month == Date().month && data.year == Date().year {
            cell.setData(data,today: T,isToggleCell: self.isToggleCell,indexPath: indexPath)
        }
        else {
            cell.setData(data,today: F,isToggleCell: self.isToggleCell,indexPath: indexPath)
        }
        
        for i in list { if data.day == i { cell.changeDisableCell() } }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { 
        let width: CGFloat = (collectionView.frame.width / 7) - 1

        self.collectionView.snp.updateConstraints {
            $0.height.equalTo(width * 6)
        }
        
        return CGSize(width: width, height: width)

    }
    
    private func toggleCell(indexPath: IndexPath) {
        if let cell = self.collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
            cell.turnOffCell()
        }
    }
    
}

extension CalendarView: CellDelegate {
    func sendCellData(_ data: Any) {
        if let data = data as? (CalendarDay, Bool) {
            printLog(data)
            self.delegate?.sendData(data)
        }
    }
    
    func sendTapCellInfo(_ data: Any) {
        if let indexPath = data as? IndexPath {
            if let beforeCell = self.selectCell{
                if beforeCell != indexPath {
                    self.toggleCell(indexPath: beforeCell)
                    self.selectCell = indexPath
                }
            } else { self.selectCell = indexPath }
        }
    }
}
