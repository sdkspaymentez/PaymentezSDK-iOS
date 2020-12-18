import Foundation

class PmzProductConfiguration: NSObject, PmzProductDisplayProtocol {
    
    var id: CLong?
    var name: String?
    var defaultValue: Bool?
    var annotation: String?
    var extraPrice: Double?
    var typeName: String?
    var appDisplayName: String?
    var subtypeName: String?
    var subTypeInternalName: String?
    var minConfiguration: Int?
    var maxConfiguration: Int?
    var displayOrder: CLong?
    var subtypeDisplayOrder: CLong?
    var isDefault: Bool?
    
    var checked: Bool = false
    
    override init(){}
    
    init(dictionary: [String: Any]) {
        if let id = dictionary["id"] as? CLong {
            self.id = id
        }
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let defaultValue = dictionary["default"] as? Bool {
            self.defaultValue = defaultValue
        }
        if let annotation = dictionary["annotations"] as? String {
            self.annotation = annotation
        }
        if let extraPrice = dictionary["extra_price"] as? Double {
            self.extraPrice = extraPrice
        }
        if let appDisplayName = dictionary["app_display_name"] as? String {
            self.appDisplayName = appDisplayName
        }
        if let typeName = dictionary["type_name"] as? String {
            self.typeName = typeName
        }
        if let subtypeName = dictionary["sub_type_name"] as? String {
            self.subtypeName = subtypeName
        }
        if let subTypeInternalName = dictionary["sub_type_internal_name"] as? String {
            self.subTypeInternalName = subTypeInternalName
        }
        if let minConfiguration = dictionary["min_configuration"] as? Int {
            self.minConfiguration = minConfiguration
        }
        if let maxConfiguration = dictionary["max_configuration"] as? Int {
            self.maxConfiguration = maxConfiguration
        }
        if let displayOrder = dictionary["display_order"] as? CLong {
            self.displayOrder = displayOrder
        }
        if let subtypeDisplayOrder = dictionary["subtype_display_order"] as? CLong {
            self.subtypeDisplayOrder = subtypeDisplayOrder
        }
        if let isDefault = dictionary["is_default"] as? Bool {
            self.isDefault = isDefault
        }
    }
    
    func getType() -> Int {
        return 1
    }
    
    func isChecked() -> Bool {
        return checked
    }
}
