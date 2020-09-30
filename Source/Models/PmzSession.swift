//
//  PmzSession.swift
//  PaymentezSDK
//
//  Created by Fennoma on 30/09/2020.
//

import Foundation

class PmzSession {
    
    var appCode: String?
    var appKey: String?
    
    init(appCode: String, appKey: String) {
        self.appCode = appCode
        self.appKey = appKey
    }
    
    func getJSONParams() -> [String: Any] {
        return [API.K.ParameterKey.appCode: appCode!, API.K.ParameterKey.appKey: appKey!]
    }
}
