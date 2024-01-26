//
//  ConnectData.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 1/2/24.
//

import UIKit

class ConnectData: NSObject {
    private let dbManager = DatabaseManager()
    private var dbCount = 0
    
    @UserDefault(key: "loginId", defaultValue: "") private var loginId
    @UserDefault(key: "tableId", defaultValue: "") private var tableId
    
    //    private override init() {
    //        super.init()
    //        dbManager.delegate = self
    //    }
    
    private func setPath(key: String? = nil) -> String {
        if let key = key {
            if key == "" { return "" }
            else { return key }
        }
        else {
            return self.loginId
        }
    }
    
    private func changeString(value: NSDictionary?) -> [String] {
        if let data = value {
            if let array = data.allKeys as? [String] { return array }
        }
        return [DB_EMPTY_ARRAY_KEY]
    }
    
    private func reserveDate(month: String, value: NSDictionary?) -> [String: [String]] {
        var monthList = [String: [String]]()
        if let data = value {
            if let array = data["\(month)"] as? [String:[String:String]] {
                for j in array.keys {
                    if let day = array["\(j)"] {
                        monthList.updateValue(day.keys.sorted(), forKey: j)
                    }
                }
            }
            
        }
        return monthList
    }
    
    // MARK: - FUNC
    func allClearData(completion: @escaping (Bool) -> Void) {
        @UserDefault(key: "loginType", defaultValue: "") var loginType
        @UserDefault(key: "pushToken", defaultValue: "") var pushToken
        @UserDefault(key: "AutoLogin", defaultValue: "") var autoLogin
        [
            .user,
            .friends,
            .reserveDate,
            .reserveList,
            .reserveGet,
            .reserveSend,
            .getFriend,
            .setReserveDate,
            .tableId
        ].forEach {
            DatabaseManager().deleteDataBase($0, key: self.loginId) { dataBase in
                if let db = dataBase as? DB_SUCCESS {
                    self.dbCount += 1
                    if self.dbCount == 9 {
                        completion(T)
                    }
                }
                else if let db = dataBase as? DB_FAILURE {
                    completion(F)
                }
            }
        }
        
        
        
        [
            _loginId,
            _loginType,
            _tableId,
            _pushToken,
            _autoLogin
        ].forEach {
            $0.removeData()
        }
    }
    // END allClearData()
    
    /// Version 데이터 불러옴
    func connectVersion(completion: @escaping (VersionAlert) -> Void) {
        DatabaseManager().readDataBase(.version, key: "") { dataBase in
            if let db = dataBase as? DB_SUCCESS {
                @UserDefault(key: "currentVer", defaultValue: "") var currentVer
                @UserDefault(key: "finalVer", defaultValue: "") var finalVer
                @UserDefault(key: "testVer", defaultValue: "N") var testVer
                if let data = db.value {
                    let forceVer = optStr(data["force"])
                    let updateVer = optStr(data["update"])
                    let choiceUpdate = optStr(data["isChoice"])
                    finalVer = optStr(data["final"])
                    currentVer = optStr(Bundle.main.infoDictionary?["CFBundleShortVersionString"])
                    
                    switch compareAppVersion(currentVer, updateVer) {
                    case .smaller :
                        testVer = "Y"
                    case .bigger, .equal:
                        testVer = "N"
                    }
                    
                    switch compareAppVersion(currentVer, finalVer) {
                    case .equal, .bigger:
                        completion(.none)
                    case .smaller:
                        switch compareAppVersion(currentVer, forceVer) {
                        case .bigger, .equal:
                            if choiceUpdate == "Y" { completion(.choice) }
                            else { completion(.none) }
                        case .smaller:
                            completion(.force)
                        }
                    }
                }
                
            }
            else if dataBase is DB_FAILURE {
                completion(.error)
            }
        }
    }
    // END connectVersion()
    
    ///.user 전용
    ///
    ///if userData.id == EMPTY_STR, userData.name == EMPTY_STR, userData.birth == EMPTY_STR, userData.isSwitch == EMPTY_STR, userData.pushToken == EMPTY_STR, userData.tableId == EMPTY_STR {}
    func connectUser(key: String? = nil,  completion: @escaping (UserData) -> Void) {
        printLog("[IN] connectUser: \(key), loginId: \(loginId)")
        var userData: UserData = .init(id: "", name: "", birth: "", isSwitch: "", pushToken: "", tableId: "")
        
        DatabaseManager().readDataBase(.user, key: self.setPath(key: key)) { dataBase in
            if let db = dataBase as? DB_SUCCESS {
//                printLog("WHAT??? :\(db.value)")
                if let data = db.value {
                    userData.id           = optStr(data["id"])
                    userData.name         = optStr(data["name"])
                    userData.birth        = optStr(data["birth"])
                    userData.isSwitch     = optStr(data["switch"])
                    userData.pushToken    = optStr(data["pushToken"])
                    userData.tableId      = optStr(data["tableId"])
                    userData.email        = optStr(data["email"]) != "" ? optStr(data["email"]) : nil
                    userData.state        = optStr(data["state"]) != "" ? optStr(data["state"]) : nil
                    
                    self.tableId = "\(userData.tableId)"
                    completion(userData)
                }
                else {
                    completion(userData)
                }
            }
            else if dataBase is DB_FAILURE {
                completion(userData)
            }
        }
    }
    // END connectUser
    
    func connectReserveList(key: String? = nil, completion: @escaping ([String]) -> Void) {
        let date = Date().convertString()
        DatabaseManager().readDataBase(.reserveList, key: "\(self.setPath(key: key))/\(date)") { dataBase in
            if let db = dataBase as? DB_SUCCESS {
                completion(self.changeString(value: db.value))
            }
            else if dataBase is DB_FAILURE {
                completion([String]())
            }
        }
    }
    // END connectReserveList
    
    func connectReserveGet(key: String? = nil, completion: @escaping ([String]) -> Void) {
        DatabaseManager().readDataBase(.reserveGet, key: self.setPath(key: key)) { dataBase in
            if let db = dataBase as? DB_SUCCESS {
                completion(self.changeString(value: db.value))
            }
            else if dataBase is DB_FAILURE {
                completion([String]())
            }
        }
        
    }
    // END connectReserveGet
    
    func connectFriends(key: String? = nil, completion: @escaping ([String]) -> Void) {
        DatabaseManager().readDataBase(.friends, key: self.setPath(key: key)) { dataBase in
            if let db = dataBase as? DB_SUCCESS {
                completion(self.changeString(value: db.value))
            }
            else if dataBase is DB_FAILURE {
                completion([String]())
            }
        }
        
    }
    // END connectFriends
    
    func connectGetFriend(key: String? = nil, completion: @escaping ([String]) -> Void) {
        
        DatabaseManager().readDataBase(.getFriend, key: self.setPath(key: key)) { dataBase in
            if let db = dataBase as? DB_SUCCESS {
                completion(self.changeString(value: db.value))
            }
            else if dataBase is DB_FAILURE {
                completion([String]())
            }
        }
    }
    // END connectGetFriend()
    
    func connectTableId(key: String? = nil, completion: @escaping ((String) -> Void)) {
        DatabaseManager().readDataBase(.tableId, key: self.setPath(key: key)) { dataBase in
            if let db = dataBase as? DB_SUCCESS {
                if let data = db.value {
                    completion(optStr(data["userId"]))
                }
            }
            else if dataBase is DB_FAILURE {
                completion("")
            }
        }
    }
    // END connectTableId()
    
    /// connectReserveDate
    ///
    /// isReserve 가  T인 경우에는 .reserveDate / F인 경우에는 .setReserveDate
    /// isNow 를 T로 설정하면 올해와 내년의 날짜만 보여줌
    ///
    func connectReserveDate(isReserve: Bool, key: String, isNow: Bool = F ,completion: @escaping ((RESERVE_LIST) -> Void)) {
        
        let type : DBType = {
            if isReserve { return .reserveDate }
            else { return .setReserveDate }
        }()
        
        DatabaseManager().readDataBase(type, key: self.setPath(key: key)) { dataBase in
            var result = RESERVE_LIST()
            if let db = dataBase as? DB_SUCCESS {
                let keysArray = self.changeString(value: db.value)
                    for i in keysArray {
                        if isNow {
                            let currentYear = Date().year
                            if i == "\(currentYear)" || i == "\(currentYear + 1)" {
                                result.updateValue(self.reserveDate(month: i, value: db.value), forKey: i)
                            }
                            else {
                                // 당해년도 + 1 오버나거나 밑
                            }
                        }
                        else {
                            result.updateValue(self.reserveDate(month: i, value: db.value), forKey: i)
                        }
                        
                    }
                completion(result)
            }
            else if dataBase is DB_FAILURE {
                completion(result)
            }
        }
    }
    // END connectReserveDate()
    
    ///connectReserveMessage
    ///
    ///if messageData.messageId == EMPTY_STR, messageData.title == EMPTY_STR, messageData.friendId == EMPTY_STR, messageData.date == EMPTY_STR, messageData.startTime == EMPTY_STR, messageData.endTime == EMPTY_STR, messageData.alarm == EMPTY_STR, messageData.state == EMPTY_STR { } else {}
    func connectReserveMessage(key: String, completion: @escaping ((MessageData) -> Void)) {
        DatabaseManager().readDataBase(.reserveMessage, key: setPath(key: key)) { dataBase in
            var messageResult = MessageData(messageId: "", title: "", friendId: "", date: "", startTime: "", endTime: "", alarm: "", state: "", location: "", etc: "")
            
            if let db = dataBase as? DB_SUCCESS {
                if let data = db.value {
                    messageResult = .init(messageId:     "\(optStr(data["date"]))\(optStr(data["startTime"]))\(optStr(data["endTime"]))\(optStr(data["friendId"]))",
                                                     title:         optStr(data["title"]),
                                                     friendId:      optStr(data["friendId"]),
                                                     date:          optStr(data["date"]),
                                                     startTime:     optStr(data["startTime"]),
                                                     endTime:       optStr(data["endTime"]),
                                                     alarm:         optStr(data["alarm"]),
                                                     state:         optStr(data["state"]),
                                                     location:      optStr(data["location"]),
                                                     etc:           optStr(data["etc"])
                    )
                    completion(messageResult)
                }
                else {
                    // 오류?
                    completion(messageResult)
                }
            }
            
            else if let db = dataBase as? DB_FAILURE {
                completion(messageResult)
            }
        }
    }
    // END connectReserveMessage()
    
}
