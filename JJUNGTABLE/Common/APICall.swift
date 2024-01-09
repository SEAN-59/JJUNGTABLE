//
//  APICall.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 1/9/24.
//

import Foundation
import Alamofire

struct APICall {
    /// geocordingAPI
    ///
    /// x = lng / y = lat
    func geocordingAPI(query: String, completion: @escaping (NaverGeocode) -> Void) {
        let param = [
            KEY.naverClientID.0: KEY.naverClientID.1,
            KEY.naverClientSecret.0: KEY.naverClientSecret.1,
            "query": query
        ]
        AF.request(KEY.naverGeocodingURL, method: .get, parameters: param).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(NaverGeocode.self, from: data)
                    completion(result)
                } catch {
                    
                }
            case .failure(let error):
                printLog(error)
            }
        }
    }
}
