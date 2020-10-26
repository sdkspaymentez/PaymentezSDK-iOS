import Foundation

class PmzMenu {
    
    var id: CLong?
    var categories: [PmzCategory]?
    
    init(dictionary: [String: Any]) {
        if let id = dictionary["menu_id"] as? CLong {
            self.id = id
        }
        if let categories = dictionary["categories"] as? NSArray {
            self.categories = categories.compactMap({
                PmzCategory(dictionary: $0 as! [String: Any])
            })
        }
    }
}
