//
//  PmzEncoder.swift
//  Alamofire
//
//  Created by Fennoma on 16/12/2020.
//

import Foundation

class PmzEncoder {
    
    static func toUTF8(string: String?) -> String {
        if let string = string {
            return String(describing: string.cString(using: String.Encoding.utf8))
        }
        return ""
    }
    
}
