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
    
    //TODO: Encode
    func addToParams(_ params: [String : Any]) -> [String : Any] {
        var modified = params
        
        modified["address_city"] = city
        modified["address_country"] = country
        modified["address_latitude"] = latitude
        modified["address_longitude"] = longitude
        modified["address_line1"] = addressLine1
        modified["address_line2"] = addressLine2
        modified["address_state"] = state
        modified["address_zip"] = zip
        return modified
    }
}
