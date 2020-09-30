//
//  PmzAddress.swift
//  PaymentezSDK
//
//  Created by Fennoma on 30/09/2020.
//

import Foundation

public class PmzAddress {
    
    public var addressLine1: String?
    public var addressLine2: String?
    public var city: String?
    public var state: String?
    public var zip: String?
    public var country: String?
    public var latitude: Double?
    public var longitude: Double?
    
    init(){}
    
    init(dictionary: [String: Any]) {
        if let addressLine1 = dictionary["address_line1"] as? String {
            self.addressLine1 = addressLine1
        }
        if let addressLine2 = dictionary["address_line2"] as? String {
            self.addressLine2 = addressLine2
        }
        if let addressCity = dictionary["address_city"] as? String {
            self.city = addressCity
        }
        if let addressState = dictionary["address_state"] as? String {
            self.state = addressState
        }
        if let addressZip = dictionary["address_zip"] as? String {
            self.zip = addressZip
        }
        if let addressCountry = dictionary["address_country"] as? String {
            self.country = addressCountry
        }
        if let addressLatitude = dictionary["address_latitude"] as? Double {
            self.latitude = addressLatitude
        }
        if let addressLongitude = dictionary["address_longitude"] as? Double {
            self.longitude = addressLongitude
        }
    }
}
