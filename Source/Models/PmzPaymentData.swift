//
//  PmzPaymentData.swift
//  Alamofire
//
//  Created by Fennoma on 18/12/2020.
//

import Foundation

public class PmzPaymentData {
    public var currency: String = "COP"
    public var amount: Double?
    public var paymentMethodReference: String?
    public var paymentReference: String?
    public var service: CLong?
    
    init() {}
    
    func setCurrency(currency: String) -> PmzPaymentData {
        self.currency = currency
        return self
    }
    
    func setAmount(amount: Double) -> PmzPaymentData {
        self.amount = amount
        return self
    }
    
    func setPaymentMethodReference(paymentMethodReference: String) -> PmzPaymentData {
        self.paymentMethodReference = paymentMethodReference
        return self
    }
    
    func setPaymentReference(paymentReference: String) -> PmzPaymentData {
        self.paymentReference = paymentReference
        return self
    }
    
    func setService(service: CLong) -> PmzPaymentData {
        self.service = service
        return self
    }
    
    func getJSONForPayment(orderId: CLong) -> [String: Any] {
        return ["amount": amount!,
                "currency": currency,
                "id_order": orderId,
                "payment_method_reference": paymentMethodReference!,
                "payment_reference": paymentReference!,
                "service": service!,
                "session": PaymentezSDK.shared.token!]
    }
    
    public static func hardcodedList() -> [PmzPaymentData] {
        var result = [PmzPaymentData]()
        for _ in 0...3 {
            let paymentData = PmzPaymentData()
                                .setAmount(amount: 17000)
                                .setPaymentMethodReference(paymentMethodReference: "PAYMENTEZ")
                                .setPaymentReference(paymentReference: "VN-100")
                                .setService(service: 0)
            result.append(paymentData)
        }
        
        return result
    }
}
