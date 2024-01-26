//
//  CloudFunctions.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 11/16/23.
//

import UIKit
import FirebaseFunctions

class CloudFunctions {
    lazy var functions = Functions.functions(region: "us-central1")
    // region 변경 시 Functions.functions(region: "us-central1")
    
    func functionCall(name: String) {
        functions.httpsCallable("helloWorld").call() { result, error in
            if let error = error as NSError?{
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    printLog("[ERROR] \(code) | \(message) | \(details)")
                }
                else {
                    printLog("ERR: \(error.localizedDescription)")
                }
            }
            printLog(result?.data)
            
            if let text = result?.data as? String {
                printLog("\(text)")
            }
        }
    }
}


// 9460 9849 7919
// 9461 8162 9010
