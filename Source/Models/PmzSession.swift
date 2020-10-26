import Foundation

class PmzSession {
    
    var appCode: String?
    var appKey: String?
    
    init(appCode: String, appKey: String) {
        self.appCode = appCode
        self.appKey = appKey
    }
}
