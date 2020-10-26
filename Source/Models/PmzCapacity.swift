import Foundation

class PmzCapacity {
    
    var storeId: CLong?
    var capacity: Int?
    var actual: Int?
    var exceeded: Bool?
    var timeRemaining: CLong?
    
    init(){}
    
    init(dictionary: [String: Any]) {
        if let storeId = dictionary["storeId"] as? CLong {
            self.storeId = storeId
        }
        if let capacity = dictionary["capacity"] as? Int {
            self.capacity = capacity
        }
        if let actual = dictionary["actual"] as? Int {
            self.actual = actual
        }
        if let exceeded = dictionary["exceeded"] as? Bool {
            self.exceeded = exceeded
        }
        if let timeRemaining = dictionary["time_remaining"] as? CLong {
            self.timeRemaining = timeRemaining
        }
    }
    
}
