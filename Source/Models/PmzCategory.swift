//
//  PmzCategory.swift
//  PaymentezSDK
//
//  Created by Fennoma on 30/09/2020.
//

import Foundation

class PmzCategory {
    
    var id: CLong?
    var name: String?
    var imageUrl: String?
    var status: Int?
    var displayOrder: Int?
    var products: [PmzProduct]?
    
    init(){}
    
    init(dictionary: [String: Any]) {
        if let id = dictionary["id"] as? CLong {
            self.id = id
        }
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let imageUrl = dictionary["image"] as? String {
            self.imageUrl = imageUrl
        }
        if let status = dictionary["status"] as? Int {
            self.status = status
        }
        if let displayOrder = dictionary["display_order"] as? CLong {
            self.displayOrder = displayOrder
        }
        if let products = dictionary["products"] as? NSArray {
            self.products = products.compactMap({
                PmzProduct(dictionary: $0 as! [String: Any])
            })
        }
    }
    
}
