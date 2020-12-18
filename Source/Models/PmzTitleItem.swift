//
//  PmzTitleItem.swift
//  Alamofire
//
//  Created by Fennoma on 11/12/2020.
//

import Foundation

class PmzTitleItem: NSObject, PmzProductDisplayProtocol {
    
    var title: String?
    
    func getType() -> Int {
        return 0
    }
    
    init(_ title: String) {
        self.title = title
    }
}
