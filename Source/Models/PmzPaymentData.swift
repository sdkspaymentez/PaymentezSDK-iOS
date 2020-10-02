//
//  PmzPaymentData.swift
//  PaymentezSDK
//
//  Created by Fennoma on 02/10/2020.
//

import Foundation

public class PmzPaymentData {
    public var amount: CLong?
    public var paymentMethodReference: String?
    public var paymentReference: String?
    public var service: CLong?
    
    public init() {}
    
    public func setAmount(_ amount: CLong) -> PmzPaymentData {
        self.amount = amount
        return self
    }
    
    public func setPaymentMethodReference(_ paymentMethodReference: String) -> PmzPaymentData {
        self.paymentMethodReference = paymentMethodReference
        return self
    }
    
    public func setPaymentReference(_ paymentReference: String) -> PmzPaymentData {
        self.paymentReference = paymentReference
        return self
    }
    
    public func setService(_ service: CLong) -> PmzPaymentData {
        self.service = service
        return self
    }
}
