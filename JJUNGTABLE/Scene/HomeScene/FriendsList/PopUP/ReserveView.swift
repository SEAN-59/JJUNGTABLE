//
//  ReserveView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 12/1/23.
//

import UIKit
import SnapKit

class ReserveView: BaseView {
    static let identifier = "ReserveView"
    weak var delegate: BaseVCDelegate?
    
    private var isCheckDate: Bool = F
    private var selectDay: CalendarDay?
//    private var selectTime : (String, String) = ("","")
    
//    private var reserveData2 = ["date": String(), "startTime":String(), "endTime":String(), "location": String()]
    
    private var reserveData = ReserveData()
    
    @IBOutlet weak var dateCheckBtn: UICustomButton!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var dateBackView: UIView!
    @IBOutlet weak var timeBackView: UIView!
    @IBOutlet weak var locationBackView: UIView!
    
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    @IBOutlet weak var addressLbl: UILabel!
    
    private lazy var emptyDateView: UIView = {
        let view = UIView()
        let emptyLbl: UILabel = {
            let lbl = UILabel()
            lbl.text = "날짜를 선택해주세요."
            lbl.font = self.yearLbl.font.withSize(20)
            lbl.textColor = .lightGray
            return lbl
        }()
        view.layer.cornerRadius = 25
        view.backgroundColor = .lightGray.withAlphaComponent(0.1)
        view.addSubview(emptyLbl)
        emptyLbl.snp.updateConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        return view
    }()
    
    private lazy var secondeReseveView: SecondReserveView = {
        let view = SecondReserveView()
        return view
    }()
    
    override func viewLoad() {
        self.setLayout()
        self.setDate(isToggleDate: F)
        self.startTimePicker.date = "0000".convertDate("HHmm").1
        self.endTimePicker.date = "0000".convertDate("HHmm").1
//        self.keyboardLayoutGuide.topAnchor.constraint(equalTo: self.etcTxf.bottomAnchor).isActive = true
//        self.checkDate()
    }
    
    func setDate(_ data: CalendarDay? = nil, isToggleDate: Bool) {
        self.selectDay = data
        if isToggleDate == T {
            if let day = self.selectDay{
                self.delegate?.sendVCData(identifier: ReserveView.identifier, data: "StopScroll")
                self.isCheckDate = F
                self.yearLbl.text = "\(day.year)"
                self.monthLbl.text = "\(day.month)"
                self.dayLbl.text = "\(day.day)"
                
                self.dateBackView.isHidden = F
                self.emptyDateView.isHidden = T
                self.changeCheckBtnImage(btn: self.dateCheckBtn)
                
            }
        }
        else {
            self.delegate?.sendVCData(identifier: ReserveView.identifier, data: "StopScroll")
            self.contentView.isHidden = T
            
            self.dateBackView.isHidden = T
            self.emptyDateView.isHidden = F
            self.emptyDateView.snp.updateConstraints {
                $0.edges.equalTo(self.dateBackView)
            }
        }
    }
    
    private func setLayout() {
        self.addSubview(self.emptyDateView)
        
        [
            self.dateBackView,
            self.timeBackView,
            self.locationBackView,
        ].forEach {
            $0?.layer.cornerRadius = 15
            $0?.backgroundColor = .lightGray.withAlphaComponent(0.1)
        }
        
        [
            self.dateCheckBtn
        ].forEach {
            $0.layer.cornerRadius = $0.layer.frame.height/2
            $0.layer.borderWidth = 2
        }
    }
    
    private func changeCheckBtnImage(btn: UICustomButton) {
        if self.isCheckDate {
            btn.setImage(UIImage(systemName: "checkmark.circle"),
                         for: .normal)
            btn.tintColor = .greenColor
            btn.setPreferredSymbolConfiguration(.init(pointSize: 20, weight: .medium),
                                                forImageIn: .normal)
            btn.configuration?.baseForegroundColor = .greenColor
            btn.setTitle("", for: .normal)
            btn.layer.borderWidth = 0
            self.contentView.isHidden = F
            self.delegate?.sendVCData(identifier: ReserveView.identifier, data: "StartScroll")
        }
        else {
            btn.setImage(.none, for: .normal)
            btn.setTitle("확인", for: .normal)
            btn.layer.borderWidth = 2
            self.contentView.isHidden = T
        }
    }
    
    private func checkDate() {
        if let date = self.selectDay {
            // year, month, day 가 전부 Int형이라서 두자리수가 아닌 경우에는
            // yyyyMMdd 형태가 아닌 yyyyMd 같은 이상한 경우가 발생함 그거 방지 목적
            let dateChange = {
                var dateSet = ("\(date.year)", "\(date.month)", "\(date.day)")
                if date.month < 10 {
                    dateSet.1 = "0\(date.month)"
                }
                if date.day < 10 {
                    dateSet.2 = "0\(date.day)"
                }
                return "\(dateSet.0)\(dateSet.1)\(dateSet.2)"
            }()
            
            // 오늘날짜 예약인 경우는 현재 시간보다 앞쪽에는 예약 못하게 해야함
            if Date().convertString() == dateChange {
                let minimum = Date().setTenMinDate()
                self.startTimePicker.minimumDate = minimum
                self.startTimePicker.date = minimum
                self.endTimePicker.date = minimum
            }
            else {
                printLog("NOT \(dateChange) , \(Date().convertString())")
                self.startTimePicker.minimumDate = .none
                self.startTimePicker.date = "0000".convertDate("HHmm").1
                self.endTimePicker.date = "0000".convertDate("HHmm").1
            }
            self.endTimePicker.minimumDate = self.startTimePicker.date
            
//            self.selectTime = (self.startTimePicker.date.convertString("HHmm"),
//                               self.endTimePicker.date.convertString("HHmm"))
            
        
//            self.reserveData2["date"] = dateChange
//            self.reserveData2["startTime"] = self.startTimePicker.date.convertString("HHmm")
//            self.reserveData2["endTime"] = self.startTimePicker.date.convertString("HHmm")
            
            self.reserveData.date = dateChange
            self.reserveData.startTime = self.startTimePicker.date.convertString("HHmm")
            self.reserveData.endTime = self.startTimePicker.date.convertString("HHmm")
        }
        
    }
    
    
    
    @IBAction func tapCheckbtn(_ sender: UICustomButton) {
        if !self.isCheckDate {
            self.isCheckDate.toggle()
            self.changeCheckBtnImage(btn: sender)
            self.checkDate()
        }
    }
    
    @IBAction func tapSearchLocationBtn(_ sender: UICustomButton) {
        let reserveMapView: ReserveMapView = {
            let view = ReserveMapView()
            return view
        }()
        
        reserveMapView.delegate = self
        self.delegate?.sendVCData(identifier: ReserveView.identifier, data: reserveMapView)
        
    }
    
    @IBAction func tapReserveBtn(_ sender: UICustomButton) {
        printLog("reseultResrve: \(self.reserveData)")
        // 이제 확인 창 하나 띄우고 다음 예약 페이지로 넘어가는거 만들면 됨
        let vc = viewControllers.last as? FriendPopUpViewController
        vc?.contentView.addSubview(self.secondeReseveView)
        self.secondeReseveView.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        if sender.tag == 0 {
            self.endTimePicker.minimumDate = sender.date
            self.endTimePicker.date = sender.date
//            self.reserveData2["startTime"] = sender.date.convertString("HHmm")
//            self.reserveData2["endTime"] = String()
            
            self.reserveData.startTime = sender.date.convertString("HHmm")
            self.reserveData.endTime = String()
        }
        else if sender.tag == 1 {
//            self.reserveData2["endTime"] = sender.date.convertString("HHmm")
            self.reserveData.endTime = sender.date.convertString("HHmm")
        }
    }
    
    
}

extension ReserveView: ViewDelegate {
    func tapCloseBtn() {
        self.delegate?.sendVCData(identifier: ReserveView.identifier, data: "close")
    }
    
    func sendViewData(identifier: String, data: Any) {
        if identifier == ReserveMapView.identifier {
            // 여기서 주소를 받아옴
            if let data = data as? String {
                self.addressLbl.text = data
//                self.reserveData2["location"] = data
                self.reserveData.location = data
            }
            printLog("HERE is ReserveView: \(data)")
        }
    }
}

// MARK: - TEXTFIELD DELEGATE
extension ReserveView {
    func textFieldDidChangeSelection(_ textField: UITextField) {
//        let text = getTextfieldValue(self.etcTxf.text)
//        printLog(text)
//        if text.count > 25 {
//            textField.text = "\(text.dropLast(1))"
//        }
    }
}

