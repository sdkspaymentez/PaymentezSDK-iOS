//
//  PmzSponsor.swift
//  PaymentezSDK
//
//  Created by Fennoma on 30/09/2020.
//

import Foundation

class PmzSponsor {
    
    var name: String?
    var logoUrl: String?
    var iconUrl: String?
    var loaderUrl: String?
    var headerEmailUrl: String?
    var colorHex: String?
    var splashUrl: String?
    var transactionSuccessUrl: String?
    var transactionErrorUrl: String?
    
    init(){}
    
    init(dictionary: [String: Any]) {
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let logoUrl = dictionary["logo"] as? String {
            self.logoUrl = logoUrl
        }
        if let iconUrl = dictionary["icon"] as? String {
            self.iconUrl = iconUrl
        }
        if let loaderUrl = dictionary["loader"] as? String {
            self.loaderUrl = loaderUrl
        }
        if let headerEmailUrl = dictionary["header_email"] as? String {
            self.headerEmailUrl = headerEmailUrl
        }
        if let colorHex = dictionary["color"] as? String {
            self.colorHex = colorHex
        }
        if let splashUrl = dictionary["splash"] as? String {
            self.splashUrl = splashUrl
        }
        if let transactionSuccessUrl = dictionary["transaction_success"] as? String {
            self.transactionSuccessUrl = transactionSuccessUrl
        }
        if let transactionErrorUrl = dictionary["transaction_error"] as? String {
            self.transactionErrorUrl = transactionErrorUrl
        }
    }
    
}
