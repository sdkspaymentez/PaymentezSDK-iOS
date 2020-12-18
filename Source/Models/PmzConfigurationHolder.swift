//
//  PmzConfigurationHolder.swift
//  Alamofire
//
//  Created by Fennoma on 11/12/2020.
//

import Foundation

class PmzConfigurationHolder: NSObject, PmzProductDisplayProtocol {
    
    var configurations: [PmzProductConfiguration]?
    
    func getType() -> Int {
        return 1
    }
    
    override init() {
        self.configurations = [PmzProductConfiguration]()
    }
    
    func add(_ config: PmzProductConfiguration) {
        self.configurations?.append(config)
    }
    
}
