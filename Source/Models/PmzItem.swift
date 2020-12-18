import Foundation

public class PmzItem {
    public var id: CLong?
    public var orderId: CLong?
    public var tax: Double?
    public var annotation: String?
    public var status: Int?
    public var totalAmount: Double?
    public var unitAmount: CLong?
    public var quantity: Int?
    public var productId: CLong?
    public var productName: String?
    public var discount: Double?
    public var imageUrl: String?
    public var configurations: [PmzConfiguration]?
    
    init(product: PmzProduct, orderId: CLong) {
        self.orderId = orderId
        self.productId = product.id
        self.annotation = product.description
        self.productName = product.name
        self.quantity = 1
    }
    
    init(dictionary: [String: Any], orderId: CLong? = 0) {
        self.orderId = orderId
        if let id = dictionary["id"] as? CLong {
            self.id = id
        }
        if let tax = dictionary["tax"] as? Double {
            self.tax = tax
        }
        if let annotation = dictionary["annotation"] as? String {
            self.annotation = annotation
        }
        if let status = dictionary["status"] as? Int {
            self.status = status
        }
        if let totalAmount = dictionary["total_amount"] as? Double {
            self.totalAmount = totalAmount
        }
        if let unitAmount = dictionary["unit_amount"] as? CLong {
            self.unitAmount = unitAmount
        }
        if let quantity = dictionary["quantity"] as? Int {
            self.quantity = quantity
        }
        if let productId = dictionary["product_id"] as? CLong {
            self.productId = productId
        }
        if let productName = dictionary["product_name"] as? String {
            self.productName = productName
        }
        if let image = dictionary["image"] as? String {
            self.imageUrl = image
        }
        if let discount = dictionary["discount"] as? Double {
            self.discount = discount
        }
        if let configurations = dictionary["configurations"] as? NSArray {
            self.configurations = configurations.compactMap({
                PmzConfiguration(dictionary: $0 as! [String: Any])
            })
        }
    }
    
    func setConfigurations(organizer: PmzProductOrganizer) {
        self.configurations = organizer.getConfigurations()
    }
    
    func getJSONWithConf() -> [String: Any] {
        //TODO: RIGHT HERE "PmzEncoder.toUTF8(string: annotation!)"
        var annotationToSend = ""
        if let annotation = annotation {
            annotationToSend = annotation
        }
        return [API.K.ParameterKey.annotations: annotationToSend,
                API.K.ParameterKey.orderId: orderId!,
                API.K.ParameterKey.productId: productId!,
                API.K.ParameterKey.quantity: quantity!,
                API.K.ParameterKey.configurations: PmzConfiguration.getJSON(configurations: configurations),
                API.K.ParameterKey.token: PaymentezSDK.shared.token!]
    }
    
    func getJSONForDelete() -> [String: Any] {
        return [API.K.ParameterKey.orderId: orderId!,
                API.K.ParameterKey.idOrderItem: id!,
                API.K.ParameterKey.token: PaymentezSDK.shared.token!]
    }
}
