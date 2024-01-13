//
//  DataModel.swift
//  SomeFuncTest
//
//  Created by Sean Kim on 2023/08/28.
//

import Foundation
// MARK: - TYPEALIAS
typealias DICT_STR = [String:String]
typealias RESERVE_LIST = [String: [String: [String]]]


//typealias DB_RESULT_STR = Result<String, DB_ERROR>
//typealias DB_RESULT_VOID = Result<(), DB_ERROR>
//
//typealias DB_RESULT_DICT = Result<NSDictionary, DB_ERROR>


typealias DB_RESULT_STR = Result<String, DB_ERROR>
typealias DB_RESULT_VOID = Result<(), DB_ERROR>
typealias DB_RESULT_DICT = Result<NSDictionary, DB_ERROR>


let DB_EMPTY_ARRAY_KEY = "EMPTYDATAARRAY"
let EMPTY_STR = ""


// MARK: - ENUM
enum CommonError: Error {
    case unownedError
    case changeError
}

enum BottomBtnType: Int {
    case homeBtn = 0
    case calendarBtn = 1
    case mapBtn = 2
    case historyBtn = 3
    case myPageBtn = 4
    case error = 5
}

enum TopBtnType: Int {
    case firstBtn = 0
    case secondBtn = 1
    case thirdBtn = 2
    case forthBtn = 3
    case fifthBtn = 4
    case error = 5
}

enum LoginType {
    case apple
    case kakao
    case test
    case error
}

enum LOGIN_ERROR: Error {
    case kakao_LoginERROR
    case kakao_AccessUserERROR
    case email_LoginERROR
    case email_CreateERROR
    case email_DeleteERROR
}
enum VersionAlert {
    case none
    case force
    case choice
    case error
}

enum AlertType {
    case top
    case center
    case bottom
}

enum DBType: String {
    case test = "test"
    case version = "version"                // 버전 정보
    
    case user = "user"                      // 내 정보
    case friends = "friends"                // 친구 리스트
    
    /// reserveMessage > (mesageID: String) > {
    ///     friendId: String,
    ///     state: String, (Y/N: default = N)
    ///     title: String,
    ///     date: String,
    ///     startTime: String,
    ///     endTime: String,
    ///     location: String?,
    ///     etc: String?
    ///  }
    ///
    /// messageID 생성 방법
    /// messageID = (date)(startTime)(endTime)(friendID)
    
/* 아래꺼 쓰면 됩니다~
    let messageId = self.dbManager.makeMessageId(<#startTime: String#>,<#endTime: String#>)
    self.dbManager.createData(.reserveMessage, key: "\(messageId)", data: [
        "friendId": "<#Friend_loginId: String#>",
        "state": "N",
        "title": "<#Title: String#>",
        "date": "<#Today: String#>",
        "startTime": "<#startTime: String#>",
        "endTime": "<#endTime: String#>",
        "alarm" : "Y",
        "location": "<#location: String#>",
        "etc": "<#etc: String#>"
    ])
 */
    case reserveMessage = "reserveMessage"  // 예약 내용

    /// reserveList > (Id) > (Y/N) > (date) > (messageID)
    case reserveList = "reserveList"        // 예약 리스트 (확정)
    
    case reserveGet = "reserveGet"          // 예약 리스트 (수신)
    case reserveSend = "reserveSend"        // 예약 리스트 (송신)
    
    /// reserveDate -> 이건 DB 만드는 방법 좀 많이 다름
    /// userID > year > month > day
    case reserveDate = "reserveDate"    // 예약 on 날짜
    
    /// tableID 생성 방법
    /// 20231231+임의 8자리의 수를 조합
    case tableId = "tableId"
    
    case getFriend = "getFriend"
    case setReserveDate = "setReserveDate"
    
    
    case refuseMessage = "refuseMessage"
}

//enum DB_ERROR: Error {
//    case db_CreateERROR
//    case db_UpdateERROR
//    case db_ReadERROR(errorKey: String = "")
//    case db_DeleteERROR
//}

enum CompareValue {
    case bigger
    case smaller
    case equal
}

enum CalendarBtn: Int {
    case prevMonth = 0
    case nextMonth = 1
}




// MARK: - STRUCT
struct CollectVersion {
    var currentVer, finalVer, testVer: String
    
    init(currentVer: String, finalVer: String, testVer: String) {
        self.currentVer = currentVer
        self.finalVer = finalVer
        self.testVer = testVer
    }
}

struct DB_SUCCESS: DataBase, @unchecked Sendable {
    let key: String
    let type: DBType
    let value: NSDictionary?
    
}

struct DB_FAILURE: DataBase {
    let key: String
    let type: DBType
}

// REMOVE : 이거 날릴거임
struct DB_ERROR: Error {
    enum DB_ERROR {
        case db_CreateERROR
        case db_UpdateERROR
        case db_ReadERROR
        case db_DeleteERROR
    }
    
    let key: String
    let db_Error: DB_ERROR
}


struct CalendarDay {
    var year, month, day, dayOfWeek: Int
    
    init(_ isInit: Bool) {
        self.year = isInit ? Date().year : -1
        self.month = isInit ? Date().month : -1
        self.day = isInit ? Date().day : -1
        self.dayOfWeek = isInit ? Date().dayOfWeek : -1
    }
}

struct LayoutStruct {
    var top, bottom, leading, trailing: Int
    
    init(top: Int, bottom: Int, leading: Int, trailing: Int) {
        self.top = top
        self.bottom = bottom
        self.leading = leading
        self.trailing = trailing
    }
}

struct LoginData{
    var id: String
    var type: LoginType
    
    init(id: String, type: LoginType) {
        self.id = id
        self.type = type
    }
}

struct UserData {
    var id, name, birth, isSwitch, pushToken, tableId: String
    var email, state: String?
    //    var image: ??
    
    init(id: String, name: String, birth: String, isSwitch: String, pushToken: String, tableId: String, email: String? = nil, state: String? = nil) {
        self.id = id
        self.name = name
        self.birth = birth
        self.isSwitch = isSwitch
        self.pushToken = pushToken
        self.email = email
        self.state = state
        self.tableId = tableId
    }
}
struct ReserveData {
    var date, startTime, endTime, location: String
    var title, etc: String
    var lat, lng: String
    
    init(date: String = String(), startTime: String = String(), endTime: String = String(), location: String = String(), title: String = String(), etc: String = String(), lat: String = String(), lng: String = String()) {
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        self.title = title
        self.etc = etc
        self.lat = lat
        self.lng = lng
    }
}

struct MessageData {
    var messageId: String
    var title, friendId, date, startTime, endTime: String
    var alarm, state, location, etc: String
    
    init(messageId: String, title: String, friendId: String, date: String, startTime: String, endTime: String, alarm: String, state: String, location: String, etc: String) {
        self.messageId = messageId
        self.title = title
        self.friendId = friendId
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.alarm = alarm
        self.state = state
        self.location = location
        self.etc = etc
    }
}

struct FriendData {
    var id, name, isSwitch, tableId: String
    var state: String?
//    var image: ??
    
    init(id: String, name: String, isSwitch: String, tableId: String, state: String? = nil) {
        self.id = id
        self.name = name
        self.isSwitch = isSwitch
        self.tableId = tableId
        self.state = state
    }
}

struct GetFriendData {
    var id, name, tableId: String
//    var image: ??
    init(id: String, name: String, tableId: String) {
        self.id = id
        self.name = name
        self.tableId = tableId
    }
}
//
//struct ReserveList {
//    var year: String
//    var month: [YearMonth]
//    
//    init(year: String, month: [YearMonth]) {
//        self.year = year
//        self.month = month
//    }
//}
//struct YearMonth {
//    var month: String
//    var day: [String]
//    
//    init(month: String, day: [String]) {
//        self.month = month
//        self.day = day
//    }
//}

struct Coordniate {
    var lat, lng : Double
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}


struct NaverGeocode: Codable {
    let addresses: [AddressCoord]
}

struct AddressCoord: Codable {
    let lat, lng, addr: String
    
    enum CodingKeys: String, CodingKey {
        case lng = "y"
        case lat = "x"
        case addr = "roadAddress"
    }
}
