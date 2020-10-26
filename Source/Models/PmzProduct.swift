import Foundation

class PmzProduct {
    
    var id: CLong?
    var name: String?
    var description: String?
    var imageUrl: String?
    var status: Int?
    var listPrice: CLong?
    var currentPrice: CLong?
    var appDisplayName: String?
    var displayOrder: CLong?
    var coverImageUrl: String?
    var storeDisabled: Bool?
    var configurations: [PmzProductConfiguration]?
    
    init(){}
    
    init(dictionary: [String: Any]) {
        if let id = dictionary["id"] as? CLong {
            self.id = id
        }
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let description = dictionary["description"] as? String {
            self.description = description
        }
        if let imageUrl = dictionary["image"] as? String {
            self.imageUrl = imageUrl
        }
        if let appDisplayName = dictionary["app_display_name"] as? String {
            self.appDisplayName = appDisplayName
        }
        if let status = dictionary["status"] as? Int {
            self.status = status
        }
        if let listPrice = dictionary["list_price"] as? CLong {
            self.listPrice = listPrice
        }
        if let currentPrice = dictionary["current_price"] as? CLong {
            self.currentPrice = currentPrice
        }
        if let displayOrder = dictionary["display_order"] as? CLong {
            self.displayOrder = displayOrder
        }
        if let storeDisabled = dictionary["store_disabled"] as? Bool {
            self.storeDisabled = storeDisabled
        }
        if let configurations = dictionary["configurations"] as? NSArray {
            self.configurations = configurations.compactMap({
                PmzProductConfiguration(dictionary: $0 as! [String: Any])
            })
        }
    }
    
}
