import Foundation

public class PmzSponsor {
    
    public var name: String?
    public var logoUrl: String?
    public var iconUrl: String?
    public var loaderUrl: String?
    public var headerEmailUrl: String?
    public var colorHex: String?
    public var splashUrl: String?
    public var transactionSuccessUrl: String?
    public var transactionErrorUrl: String?
    
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
