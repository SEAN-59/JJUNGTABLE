//
//  FriendPopUpViewController.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 12/1/23.
//

import UIKit
import SnapKit

//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//#Preview(traits: .portrait, body: {
//    FriendPopUpViewController()
////        .sendData("calendar", friendId: "20231225")
//})

class FriendPopUpViewController: BaseVC {
    private var date = CalendarDay(T)
    
    private var viewName = ""
    private var friendId = ""
    private var reserveDateList = RESERVE_LIST()
    private var setReserveDateList = RESERVE_LIST()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    private lazy var calendarView: CalendarView = {
        let view = CalendarView()
        return view
    }()
    
    private lazy var reserveView: ReserveView = {
        let view = ReserveView()
        return view
    }()
    
    private lazy var situationView: CalendarSituationView = {
        let view = CalendarSituationView()
        return view
    }()
    
    private lazy var separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
//        view.backgroundColor = .red
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView.delegate = self
        
        self.setDrawView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func sendData(_ name: String, friendId: String) {
        self.viewName = name
        self.friendId = friendId
    }
    
    private func setDrawView() {
        if self.viewName == "calendar" {
            self.titleLbl.text = "일정 확인"
        }
        
        else if self.viewName == "reserve" {
            self.titleLbl.text = "예약 하기"
        }
        ConnectData().connectReserveDate(isReserve: T, key: self.friendId, isNow: T) { reserveData in
//            for i in dateData {
                // success or failure 뭐든 일단 . setReserveDate
            ConnectData().connectReserveDate(isReserve: F, key: self.friendId, isNow: T) { serResrveData in
                if self.viewName == "calendar" {
                    self.setCalendarSituation() // 현황에 데이터 넣기 위해서 동작
                    self.addCalendarView() // 캘린더 그리는 동작
                    
                    self.calendarView.setData(T, dict: [reserveData, serResrveData])
                }
                else if self.viewName == "reserve" {
                    self.addReserveView()
                    self.calendarView.setData(T, dict: [reserveData, serResrveData]
                                              ,isToggleCell: T
                                              ,isCellConnect: F
                                              ,isBeforeToday: T
                    )
                }
            }
            // 이게 만약에 실패를 하게 되면 다음과 같은 동작을 하게 되어있던데 맞는건지 확인 해야 함
            /*
             if self.viewName == "calendar" {
                 self.setCalendarSituation() // 현황에 데이터 넣기 위해서 동작
                 self.addCalendarView()
                 self.calendarView.setData(true,
                                          dict: [self.reserveDateList, self.setReserveDateList])
             }
             
             else if self.viewName == "reserve" {
                 self.addReserveView()
                 self.calendarView.setData(true,
                                          dict: [self.reserveDateList, self.setReserveDateList]
                                           ,isToggleCell: T
                                           ,isCellConnect: F)
             }
             */
        }
    }
    private func addBaseView() {
        [
            self.calendarView,
            self.separateView,
            self.scrollView
        ].forEach { self.contentView.addSubview($0) }
        
        self.calendarView.snp.updateConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        self.separateView.snp.updateConstraints {
            $0.height.equalTo(2)
            $0.top.equalTo(self.calendarView.snp.bottom).inset(-5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        self.scrollView.snp.updateConstraints {
            $0.width.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.separateView.snp.bottom).inset(-5)
        }
        
    }
    private func addReserveView() {
        self.reserveView.delegate = self
        self.addBaseView()
        self.scrollView.addSubview(self.reserveView)
        self.reserveView.snp.updateConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(self.scrollView.frameLayoutGuide.snp.width)
        }
        
//        self.view.keyboardLayoutGuide.topAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
    }
    
    private func addCalendarView() {
        self.addBaseView()
        
        self.scrollView.addSubview(self.situationView)
        self.situationView.snp.updateConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(self.scrollView.frameLayoutGuide.snp.width)
        }
        
    }
    
    private func setCalendarSituation() {
        var result = [Int]()
        if let monthList = self.reserveDateList["\(self.date.year)"] {
            if let dayList = monthList["\(self.date.month)"] {
                for i in dayList {
                    result.append(i.stringToInt())
                }
            }
        }
        if let monthList = self.setReserveDateList["\(self.date.year)"] {
            if let dayList = monthList["\(self.date.month)"] {
                for i in dayList {
                    if result.firstIndex(of: i.stringToInt()) == nil {
                        result.append(i.stringToInt())
                    }
                }
            }
        }
        
        let end: Int = String
            .combineDate(year: self.date.year,
                         month: self.date.month,
                         day: self.date.day)
            .convertDate().1
            .getLastDayOfMonth()
        
        // 평일 가능, 평일 불가능, 휴일 가능, 휴일 불가능
        var list = [0,0,0,0]
        
        // 주말 갯수 구하기
        var holydayCnt = 0
        for i in 1...end {
            if !(1..<6 ~= String
                .combineDate(year: self.date.year,
                             month: self.date.month,
                             day: i)
                .convertDate().1
                .dayOfWeek) {
                holydayCnt += 1
            }
        }
        
        // 불가능 날짜 구하기
        for i in result {
            
            // 평일 안되는 날짜
            if 1..<6 ~= String
                .combineDate(year: self.date.year,
                             month: self.date.month,
                             day: i)
                .convertDate().1
                .dayOfWeek {
                list[1] += 1
            }
            // 휴일 안되는 날짜
            else {
                list[3] += 1
            }
        }
        
        list[2] = holydayCnt - list[3]
        list[0] = end - (list[1] + list[2] + list[3])
        
        self.situationView.setData(self.date.month, list)
    }
    
    @IBAction func tapCloseBtn(_ sender: UICustomButton) {
        self.dismiss(animated: T)
    }
    
    
    
}

extension FriendPopUpViewController: CalendarViewDelegate {
    func sendData(_ data: Any) {
        printLog("\(data)")
        
        if let data = data as? (CalendarDay, Bool) {
            if self.viewName == "reserve" {self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                self.reserveView.setDate(data.0, isToggleDate: data.1)
            }
        }
    }
    
    func moveMonth(_ data: Any) {
        if let date = data as? CalendarDay {
            self.date = date
            self.setCalendarSituation()
        }
    }
    
}


extension FriendPopUpViewController: BaseVCDelegate {
    // ReserveView에서 뭔가를 보낼건데 그게 여기들어오는걸 구분 해야 함
    func sendVCData(_ data: Any) {
        if let data = data as? [String: Any] {
            if let view = data["\(ReserveView.identifier)"] as? UIView {
                let nextVC = CommonAlertViewController(nibName: "CommonAlertViewController",
                                                       bundle: nil)
                nextVC.setUpAlertVC(view, animate: F, type: .center, isKeyBoard: T)
                self.presentVC(fromVC: self, nextVC: nextVC, presentAnimate: F)
            }
        }
        
        if let data = data as? String {
            if data == "close" {
                self.dismiss(animated: F)
            }
        }
    }
}
