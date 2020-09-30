//
//  PmzItem.swift
//  PaymentezSDK
//
//  Created by Fennoma on 21/09/2020.
//

import Foundation

public class PmzItem {
    public var id: CLong?
    public var orderId: CLong?
    public var tax: Double?
    public var annotation: String?
    public var status: Int?
    public var totalAmount: CLong?
    public var unitAmount: CLong?
    public var quantity: Int?
    public var productId: CLong?
    public var productName: String?
    public var discount: Double?
    public var configurations: [PmzConfiguration]?
    
    init(dictionary: [String: Any]) {
        if let id = dictionary["id"] as? CLong {
            self.id = id
        }
        if let tax = dictionary["tax"] as? Double {
            self.tax = tax
        }
        if let annotation = dictionary["annotation"] as? String {
            self.annotation = annotation
        }
        if let status = dictionary["status"] as? Int {
            self.status = status
        }
        if let totalAmount = dictionary["total_amount"] as? CLong {
            self.totalAmount = totalAmount
        }
        if let unitAmount = dictionary["unit_amount"] as? CLong {
            self.unitAmount = unitAmount
        }
        if let quantity = dictionary["quantity"] as? Int {
            self.quantity = quantity
        }
        if let productId = dictionary["product_id"] as? CLong {
            self.productId = productId
        }
        if let productName = dictionary["product_name"] as? String {
            self.productName = productName
        }
        if let discount = dictionary["discount"] as? Double {
            self.discount = discount
        }
        if let configurations = dictionary["configurations"] as? NSArray {
            self.configurations = configurations.compactMap({
                PmzConfiguration(dictionary: $0 as! [String: Any])
            })
        }
    }
    
    func getJSONWithConf() -> [String: Any] {
        return [API.K.ParameterKey.annotations: annotation!,
                API.K.ParameterKey.orderId: orderId!,
                API.K.ParameterKey.productId: productId!,
                API.K.ParameterKey.quantity: quantity!,
                API.K.ParameterKey.configurations: PmzConfiguration.getJSON(configurations: configurations),
                API.K.ParameterKey.token: PaymentezSDK.shared.token!]
    }
}
