//
//  PmzOrder.swift
//  PaymentezSDK
//
//  Created by Fennoma on 21/09/2020.
//

import Foundation

public class PmzOrder {
    
    public var id: CLong?
    public var status: Int?
    public var tax: Double?
    public var buyerEmail: String?
    public var buyerName: String?
    public var buyerPhone: String?
    public var buyerFiscalNumber: String?
    public var userReference: String?
    public var orderAppReference: String?
    public var confirmationCode: String?
    public var tableReference: String?
    public var deliveryDate: String?
    public var reserveCode: String?
    public var datePlaced: String?
    public var dateStarted: String?
    public var orderType: Int?
    public var totalAmount: CLong?
    public var addressLine1: String?
    public var addressLine2: String?
    public var addressCity: String?
    public var addressState: String?
    public var addressZip: String?
    public var addressCountry: String?
    public var addressLatitude: Double?
    public var addressLongitude: Double?
    public var deliveryInstructions: String?
    public var deliveryPrice: Double?
    public var statusDescription: String?
    public var items: [PmzItem]?
    
    init(){}
    
    init(dictionary: [String: Any]) {
        if let id = dictionary["id"] as? CLong {
            self.id = id
        }
        if let status = dictionary["status"] as? Int {
            self.status = status
        }
        if let tax = dictionary["tax"] as? Double {
            self.tax = tax
        }
        if let buyerEmail = dictionary["buyer_email"] as? String {
            self.buyerEmail = buyerEmail
        }
        if let buyerName = dictionary["buyer_name"] as? String {
            self.buyerName = buyerName
        }
        if let buyerFiscalNumber = dictionary["buyer_fiscal_number"] as? String {
            self.buyerFiscalNumber = buyerFiscalNumber
        }
        if let userReference = dictionary["user_reference"] as? String {
            self.userReference = userReference
        }
        if let orderAppReference = dictionary["order_app_reference"] as? String {
            self.orderAppReference = orderAppReference
        }
        if let confirmationCode = dictionary["confirmation_code"] as? String {
            self.confirmationCode = confirmationCode
        }
        if let tableReference = dictionary["table_reference"] as? String {
            self.tableReference = tableReference
        }
        if let deliveryDate = dictionary["delivery_date"] as? String {
            self.deliveryDate = deliveryDate
        }
        if let reserveCode = dictionary["reserve_code"] as? String {
            self.reserveCode = reserveCode
        }
        if let datePlaced = dictionary["date_placed"] as? String {
            self.datePlaced = datePlaced
        }
        if let dateStarted = dictionary["date_started"] as? String {
            self.dateStarted = dateStarted
        }
        if let orderType = dictionary["order_type"] as? Int {
            self.orderType = orderType
        }
        if let totalAmount = dictionary["total_amount"] as? CLong {
            self.totalAmount = totalAmount
        }
        if let addressLine1 = dictionary["address_line1"] as? String {
            self.addressLine1 = addressLine1
        }
        if let addressLine2 = dictionary["address_line2"] as? String {
            self.addressLine2 = addressLine2
        }
        if let addressCity = dictionary["address_city"] as? String {
            self.addressCity = addressCity
        }
        if let addressState = dictionary["address_state"] as? String {
            self.addressState = addressState
        }
        if let addressZip = dictionary["address_zip"] as? String {
            self.addressZip = addressZip
        }
        if let addressCountry = dictionary["address_country"] as? String {
            self.addressCountry = addressCountry
        }
        if let deliveryInstructions = dictionary["delivery_instructions"] as? String {
            self.deliveryInstructions = deliveryInstructions
        }
        if let addressLatitude = dictionary["address_latitude"] as? Double {
            self.addressLatitude = addressLatitude
        }
        if let addressLongitude = dictionary["address_longitude"] as? Double {
            self.addressLongitude = addressLongitude
        }
        if let deliveryPrice = dictionary["delivery_price"] as? Double {
            self.deliveryPrice = deliveryPrice
        }
        if let statusDescription = dictionary["status_description"] as? String {
            self.statusDescription = statusDescription
        }
        if let content = dictionary["items"] as? NSArray {
            self.items = content.compactMap({
                PmzItem(dictionary: $0 as! [String: Any])
            })
        }
    }
    
    public static func hardcoded() -> PmzOrder {
        if let dic = convertStringToDictionary(text: PmzOrder.json) {
            return PmzOrder(dictionary: dic)
        } else {
            return PmzOrder()
        }
    }
    
    static func convertStringToDictionary (text:String) -> [String: Any]? {
        do {
            let data: Data = text.data(using: String.Encoding.utf8)!
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            return nil
        }
    }
    
    static let json = "{\n" +
    "    \"id\": 8493,\n" +
    "    \"status\": 0,\n" +
    "    \"tax\": 0,\n" +
    "    \"items\": [\n" +
    "      {\n" +
    "        \"id\": 15053,\n" +
    "        \"tax\": 0,\n" +
    "        \"annotations\": \"sin servilletas\",\n" +
    "        \"status\": 0,\n" +
    "        \"configurations\": [\n" +
    "          {\n" +
    "            \"id\": 13015,\n" +
    "            \"annotations\": null,\n" +
    "            \"description\": \"Ajonjolí\",\n" +
    "            \"type\": 2,\n" +
    "            \"cost\": 1000,\n" +
    "            \"configuration_id\": 11520,\n" +
    "            \"discount\": null\n" +
    "          },\n" +
    "          {\n" +
    "            \"id\": 13016,\n" +
    "            \"annotations\": null,\n" +
    "            \"description\": \"Cubiertos\",\n" +
    "            \"type\": 2,\n" +
    "            \"cost\": 0,\n" +
    "            \"configuration_id\": 11494,\n" +
    "            \"discount\": null\n" +
    "          }\n" +
    "        ],\n" +
    "        \"total_amount\": 17000,\n" +
    "        \"unit_amount\": 16000,\n" +
    "        \"quantity\": 1,\n" +
    "        \"product_id\": 7351,\n" +
    "        \"product_name\": \"Ceviche\",\n" +
    "        \"discount\": null\n" +
    "      }\n" +
    "    ],\n" +
    "    \"buyer_email\": \"breyes@paymentez.com\",\n" +
    "    \"buyer_name\": \"Bruno Reyes\",\n" +
    "    \"buyer_phone\": \"3212000915\",\n" +
    "    \"buyer_fiscal_number\": \"1054092666\",\n" +
    "    \"user_reference\": \"f6dc275d-5e64-4127-bf5c-dbbfac02aacd\",\n" +
    "    \"order_app_reference\": \"test-1744\",\n" +
    "    \"confirmation_code\": null,\n" +
    "    \"table_reference\": null,\n" +
    "    \"delivery_date\": null,\n" +
    "    \"reserve_code\": null,\n" +
    "    \"date_placed\": null,\n" +
    "    \"date_started\": \"2020-09-17T10:48:24.000Z\",\n" +
    "    \"order_type\": 0,\n" +
    "    \"total_amount\": 17000,\n" +
    "    \"address_line1\": \"Calle 75 20C-81\",\n" +
    "    \"address_line2\": \"Calle 75 - 20C-81\",\n" +
    "    \"address_city\": \"Bogotá\",\n" +
    "    \"address_state\": \"DC\",\n" +
    "    \"address_zip\": \"00000\",\n" +
    "    \"address_country\": \"Colombia\",\n" +
    "    \"address_latitude\": 4.6568103,\n" +
    "    \"address_longitude\": -74.0561968,\n" +
    "    \"delivery_instructions\": \"Apto 206\",\n" +
    "    \"delivery_price\": 0,\n" +
    "    \"status_description\": null\n" +
    "  }"
}
