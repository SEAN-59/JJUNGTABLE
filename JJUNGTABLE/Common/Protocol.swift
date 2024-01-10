//
//  Protocol.swift
//  SomeFuncTest
//
//  Created by Sean Kim on 2023/09/26.
//

import Foundation
import CoreLocation

public protocol DataBase {}

protocol LocationDelegate: AnyObject {
    func checkPermission(_ type: Bool)
    func getLocation(_ location: CLLocation)
}

extension LocationDelegate {
    func checkPermission(_ type: Bool) {}
    func getLocation(_ location: CLLocation) {}
}

// MARK: - Navigation
protocol bottomButtonDelegate: AnyObject{
    func tapBottomButton(_ buttonType: BottomBtnType)
}

protocol topButtonDelegate: AnyObject{
    func tapTopButton(_ buttonType: TopBtnType)
}

// MARK: - DataBase Manager
protocol DatabaseDelegate: AnyObject {
    func updateData(_ type: DBType,_ result: DB_RESULT_STR)
    
    func readData(_ type: DBType,_ result: DB_RESULT_DICT)
    
    func deleteData(_ type: DBType,_ result: DB_RESULT_STR)
}

extension DatabaseDelegate {
    func updateData(_ type: DBType,_ result: DB_RESULT_STR) {}
    
    func readData(_ type: DBType,_ result: DB_RESULT_DICT) {}
    
    func deleteData(_ type: DBType,_ result: DB_RESULT_STR) {}
}

// MARK: - ConnectData
protocol ConnectDelegate: AnyObject {
//    func
    // 어쨌든 여기는 디비랑 연결해서 읽는 작업 밖에 안함, 업데이트나 이런건 각 VC에서 할 문제임
    // 뭐든 끝나게 되면 그 type이랑
}
extension ConnectDelegate {
    
}

// MARK: - View Move
// view에서 VC로 데이터를 연결해야 하는데 할 마땅한 방법이 없을 경우 이용
protocol BaseVCDelegate: AnyObject {
    func reloadVC()
    func doVCSomething()
    func sendVCData(identifier: String, data: Any)
}
extension BaseVCDelegate {
    func reloadVC() {}
    func doVCSomething() {}
    func sendVCData(identifier: String, data: Any){}
}
// MARK: - CELL
// 이건 어느거든 cell 이 값을 보낼때 사용
protocol CellDelegate: AnyObject {
    func doCellSomething()
    func sendCellData(_ data: Any)
    func sendTapCellInfo(_ data: Any)
}
extension CellDelegate {
    func doCellSomething() {}
    func sendCellData(_ data: Any) {}
    func sendTapCellInfo(_ data: Any) {}
}
// MARK: - VIEW
// 이건 View -> View 로 보내는 경우?
protocol ViewDelegate: AnyObject {
    func doViewSomething()
    func sendViewData(identifier: String, data: Any)
    func tapCloseBtn()
}

extension ViewDelegate {
    func doViewSomething() {}
    func sendViewData(identifier: String, data: Any) {}
    func tapCloseBtn() {}
}

// MARK: - VIEW
    // CalendarView
protocol CalendarViewDelegate: AnyObject {
    // CalendaraView 자체적으로 Data
    func sendData(_ data: Any)
    func sendTapCellInfo(_ data: Any)
    func moveMonth(_ data: Any)
}
extension CalendarViewDelegate {
    func sendData(_ data: Any) {}
    func sendTapCellInfo(_ data: Any) {}
    func moveMonth(_ data: Any) {}
}



