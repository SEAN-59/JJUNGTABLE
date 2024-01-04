//
//  DatabaseManager.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 11/1/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
      
class DatabaseManager {
    var ref: DatabaseReference?
//    weak var delegate: DatabaseDelegate?
    
    init(ref: DatabaseReference? = nil, delegate: DatabaseDelegate? = nil) {
        self.ref = Database.database().reference()
//        self.delegate = delegate
    }
    
    deinit {
        printLog("[deinit] DatabaseManager_deinit")
    }
    
    func test() {
        if let ref = ref {
            ref.child("tableId").setValue(["ad":"w3"])
            
        }
    }
    
    // MARK: - Completion
    
    /// Completion 활용한 DB_Read
    ///
    /// if let db = dataBase as? DB_SUCCESS {} else if let db = dataBase as? DB_FAILURE {}
    func readDataBase(_ dbType: DBType, key: String, completion: @escaping (DataBase) -> Void) {
        // key 가 빈값으로 올 경우 바로 Type으로 만들지만 그게 아니고 key에 다른 주소가 같이 들어온다면 그 부분을 포함해서 주소 구성
        let path: String = {
            if key == "" { return "\(dbType)" }
            else { return "\(dbType)/\(key)" }
        }()
        
        if let ref = ref {
            ref.child("\(path)").getData { error, snapshot in
                if let error = error {
                    printLog("[ERROR] ref READ ERROR: \n\(dbType) \n\(error)")
                    completion(DB_FAILURE(key: key, type: dbType))
                }
                else {
                    if let snapshot = snapshot {
                        let value = snapshot.value as? NSDictionary
                        printLog("success readDB \n\(dbType) \n\(String(describing: value))")
                        completion(DB_SUCCESS(key: key, type: dbType, value: value))
                    }
                }
            }
        }
    }
    
    /// Completion 활용한 Create
    ///
    /// if let db = dataBase as? DB_SUCCESS {} else if let db = dataBase as? DB_FAILURE {}
    func createDataBase(_ dbType: DBType, key: String, data: [String:String], completion: @escaping (DataBase) -> Void) {
        let path: String = {
            if key == "" { return "\(dbType)" }
            else { return "\(dbType)/\(key)" }
        }()
        
        if let ref = ref {
            ref.child("\(path)").setValue(data) { error, _ in
                if error != nil {
                    printLog("[ERROR] Create Database")
                    completion(DB_FAILURE(key: key, type: dbType))
                }
                else {
                    completion(DB_SUCCESS(key: key, type: dbType, value: nil))
                }
            }
        }
    }
    
    /// Completion 활용한 Update
    ///
    /// if let db = dataBase as? DB_SUCCESS {} else if let db = dataBase as? DB_FAILURE {}
    func updateDataBase(_ dbType: DBType, key: String, data: String, completion: @escaping (DataBase) -> Void) {
        let path: String = {
            if key == "" { return "\(dbType)" }
            else { return "\(dbType)/\(key)" }
        }()
        
        if let ref = ref {
            ref.child("\(path)").setValue(data) { error, _ in
                if error != nil {
                    printLog("[ERROR] Update Database")
                    completion(DB_FAILURE(key: key, type: dbType))
                }
                else {
                    completion(DB_SUCCESS(key: key, type: dbType, value: nil))
                }
            }
        }
    }
    
    /// Completion 활용한 Delete
    ///
    /// if let db = dataBase as? DB_SUCCESS {} else if let db = dataBase as? DB_FAILURE {}
    func deleteDataBase(_ dbType: DBType, key: String, completion: @escaping (DataBase) -> Void) {
        let path: String = {
            if key == "" { return "\(dbType)" }
            else { return "\(dbType)/\(key)" }
        }()
        
        if let ref = ref {
            ref.child("\(path)").removeValue { error, _ in
                if let error = error {
                    completion(DB_FAILURE(key: key, type: dbType))
                }
                else {
                    completion(DB_SUCCESS(key: key, type: dbType, value: nil))
                }
            }
        }
    }
    
    
    
    // MARK: - DELEGATE
//    func createData(_ dbType: DBType, key: String, data: [String:String]) {
//        let path: String = {
//            if key == "" { return "\(dbType)" }
//            else { return "\(dbType)/\(key)" }
//        }()
//        
//        if let ref = ref {
//            ref.child("\(path)").setValue(data) { error, _ in
//                if error != nil {
//                    printLog("[ERROR] Create Database")
//                    self.delegate?.updateData(dbType,.failure(DB_ERROR(key: key, db_Error: .db_CreateERROR)))
//                }
//                else {
//                    self.delegate?.updateData(dbType,.success(""))
//                }
//            }
//        }
//    }
//    
//    func updateData(_ dbType: DBType, key: String, data: String) {
//        let path: String = {
//            if key == "" { return "\(dbType)" }
//            else { return "\(dbType)/\(key)" }
//        }()
//        
///*
//        //혹시 모를 String 말고 다른 딕셔너리나 이런거 들어오는 경우대비 했던것
//        var convertData: Any
//        if isDict {
//            guard let dictData = data as? [String : String] else {
//                self.delegate?.updateData(dbType,.failure(.db_UpdateERROR))
//                return
//            }
//            convertData = dictData
//        } else {
//            guard let strData = data as? String else {
//                self.delegate?.updateData(dbType,.failure(.db_UpdateERROR))
//                return
//            }
//            convertData = strData
//        }
// */
//        
//        // 근데 업뎃이랑 크리에이트랑 다른게 없는데 이렇게 하는게 맞나?
//        if let ref = ref {
//            ref.child("\(path)").setValue(data) { error, _ in
//                if error != nil {
//                    printLog("[ERROR] Update Database")
//                    self.delegate?.updateData(dbType,.failure(DB_ERROR(key: key, db_Error: .db_UpdateERROR)))
//                }
//                else {
//                    self.delegate?.updateData(dbType,.success(""))
//                }
//            }
//
//        }
//    }
//    
//    
//    // REMOVE
//    func readData(_ dbType: DBType, key: String) {
//        let path: String = {
//            if key == "" { return "\(dbType)" }
//            else { return "\(dbType)/\(key)" }
//        }()
//        
//        if let ref = ref {
//            ref.child("\(path)").getData { error, snapshot in
//                if let error = error {
//                    printLog("[ERROR] ref READ ERROR: \(error)")
//                    self.delegate?.readData(dbType, .failure(DB_ERROR(key: key, db_Error: .db_ReadERROR)))
//                }
//                else {
//                    if let snapshot = snapshot {
//                        let value = snapshot.value as? NSDictionary
//                        printLog("success readDB \(String(describing: value))")
//                        if let value = value  {
//                            self.delegate?.readData(dbType,.success(value))
//                        } else {
//                            printLog("DATA BASE READ FAIL: \(dbType)")
//                            self.delegate?.readData(dbType, .failure(DB_ERROR(key: key, db_Error: .db_ReadERROR)))
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    func deleteData(_ dbType: DBType, key: String) {
//        let path: String = {
//            if key == "" { return "\(dbType)" }
//            else { return "\(dbType)/\(key)" }
//        }()
//        
//        if let ref = ref {
//            ref.child("\(path)").removeValue { error, _ in
//                if let error = error {
//                    printLog("[ERROR] Delete Database: \(error)")
//                    self.delegate?.deleteData(dbType, .failure(DB_ERROR(key: key, db_Error: .db_DeleteERROR)))
//                }
//                else {
//                    self.delegate?.deleteData(dbType, .success("\(key)"))
//                }
//            }
//        }
//    }
    
    // MARK: - 기타 함수
    
    func makeRandomArray(digit: Int) -> [Int]{
        var result = [Int]()
        
        for _ in 0 ..< digit {
            result.append(Int.random(in: 0...9))
        }
        return result
    }
    
    func makeTableID() -> String {
        var result = ""
        let array = self.makeRandomArray(digit: 8)
        let date = Date().convertString("yyyyMMdd").letter()
        printLog("\(array)")
        printLog("\(date)")
        for i in 0 ..< 8 {
            result.append("\(date[i])")
            result.append("\(array[i])")
        }
        return result
    }

    /// messageID = (date)(startTime)(endTime)(friendID)
    func makeMessageId(_ startTime: String, _ endTime: String) -> String {
        @UserDefault(key: "loginId", defaultValue: "") var loginId
        let date = Date().convertString()
        return "\(date)\(startTime)\(endTime)\(loginId)"
        // TEST
//        return "\(date)\(startTime)\(endTime)23039923"
    }
}
