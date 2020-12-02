import Foundation

public class PmzError {
    public static let PLACE_ERROR_KEY: String = "place error"
    public static let PAYMENT_ERROR_KEY: String = "payment error"
    public static let NO_ORDER_SET_ERROR_KEY: String = "no order set error"
    public static let SERVICE_ERROR: String = "service error"
    
    public var errorCode: String?
    public var errorMessage: String?
    
    init(){}
    
    init(_ errorCode: String) {
        self.errorCode = errorCode
    }
    
    init(_ errorCode: String, _ message: String) {
        self.errorCode = errorCode
    }
}
