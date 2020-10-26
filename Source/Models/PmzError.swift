import Foundation

public class PmzError {
    public static let PLACE_ERROR_KEY: String = "place error"
    public static let PAYMENT_ERROR_KEY: String = "payment error"
    public static let NO_ORDER_SET_ERROR_KEY: String = "no order set error"
    
    public var type: String?
    
    init(){}
    
    init(type: String) {
        self.type = type
    }
    
}
