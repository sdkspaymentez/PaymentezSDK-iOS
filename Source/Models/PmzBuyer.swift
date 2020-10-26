import Foundation

public class PmzBuyer {
    
    public var name: String?
    public var email: String?
    public var phone: String?
    public var fiscalNumber: String?
    public var userReference: String?
    
    public init(){}
    
    init(dictionary: [String: Any]) {
        if let buyerEmail = dictionary["buyer_email"] as? String {
            self.email = buyerEmail
        }
        if let buyerName = dictionary["buyer_name"] as? String {
            self.name = buyerName
        }
        if let buyerPhone = dictionary["buyer_phone"] as? String {
            self.phone = buyerPhone
        }
        if let buyerFiscalNumber = dictionary["buyer_fiscal_number"] as? String {
            self.fiscalNumber = buyerFiscalNumber
        }
        if let userReference = dictionary["user_reference"] as? String {
            self.userReference = userReference
        }
    }
    
    public func setName(_ name: String) -> PmzBuyer {
        self.name = name
        return self
    }
    
    public func setEmail(_ email: String) -> PmzBuyer {
        self.email = email
        return self
    }
    
    public func setPhone(_ phone: String) -> PmzBuyer {
        self.phone = phone
        return self
    }
    
    public func setFiscalNumber(_ fiscalNumber: String) -> PmzBuyer {
        self.fiscalNumber = fiscalNumber
        return self
    }
    
    public func setUserReference(_ userReference: String) -> PmzBuyer {
        self.userReference = userReference
        return self
    }
}
