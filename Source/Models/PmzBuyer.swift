import Foundation

public class PmzBuyer {
    
    public var name: String?
    public var email: String?
    public var phone: String?
    public var fiscalNumber: String?
    public var userReference: String?
    
    init(){}
    
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
    
}
