import Foundation

public class PmzOrder {
    
    public var id: CLong?
    public var status: Int?
    public var tax: Double?
    public var orderAppReference: String?
    public var confirmationCode: String?
    public var tableReference: String?
    public var deliveryDate: String?
    public var reserveCode: String?
    public var datePlaced: String?
    public var dateStarted: String?
    public var orderType: Int?
    public var totalAmount: Double?
    public var deliveryInstructions: String?
    public var deliveryPrice: Double?
    public var statusDescription: String?
    
    public var annotations: String?
    public var storeId: CLong?
    public var typeOrder: Int?
    public var currency: String?
    public var paymentMethodReference: String?
    public var paymentReference: String?
    public var service: Int?
    
    public var appOrderReference: String?
    
    public var store: PmzStore?
    
    public var items: [PmzItem]?
    public var buyer: PmzBuyer?
    public var address: PmzAddress?
    
    init(){}
    
    init(buyer: PmzBuyer, appOrderReference: String, storeId: CLong) {
        self.buyer = buyer
        self.appOrderReference = appOrderReference
        self.storeId = storeId
        self.annotations = ""
        self.typeOrder = 0
    }
    
    init(dictionary: [String: Any]) {
        if let id = dictionary["id"] as? CLong {
            self.id = id
        }
        if let status = dictionary["status"] as? Int {
            self.status = status
        }
        if let tax = dictionary["tax"] as? Double {
            self.tax = tax
        }
        if let orderAppReference = dictionary["order_app_reference"] as? String {
            self.orderAppReference = orderAppReference
        }
        if let confirmationCode = dictionary["confirmation_code"] as? String {
            self.confirmationCode = confirmationCode
        }
        if let tableReference = dictionary["table_reference"] as? String {
            self.tableReference = tableReference
        }
        if let deliveryDate = dictionary["delivery_date"] as? String {
            self.deliveryDate = deliveryDate
        }
        if let reserveCode = dictionary["reserve_code"] as? String {
            self.reserveCode = reserveCode
        }
        if let datePlaced = dictionary["date_placed"] as? String {
            self.datePlaced = datePlaced
        }
        if let dateStarted = dictionary["date_started"] as? String {
            self.dateStarted = dateStarted
        }
        if let orderType = dictionary["order_type"] as? Int {
            self.orderType = orderType
        }
        if let totalAmount = dictionary["total_amount"] as? Double {
            self.totalAmount = totalAmount
        }
        if let deliveryInstructions = dictionary["delivery_instructions"] as? String {
            self.deliveryInstructions = deliveryInstructions
        }
        if let deliveryPrice = dictionary["delivery_price"] as? Double {
            self.deliveryPrice = deliveryPrice
        }
        if let statusDescription = dictionary["status_description"] as? String {
            self.statusDescription = statusDescription
        }
        if let content = dictionary["items"] as? NSArray {
            self.items = content.compactMap({
                PmzItem(dictionary: $0 as! [String: Any], orderId: id)
            })
        }
        self.buyer = PmzBuyer(dictionary: dictionary)
        self.address = PmzAddress(dictionary: dictionary)
        
        if let annotations = dictionary["Annotations"] as? String {
            self.annotations = annotations
        }
        if let storeId = dictionary["id_store"] as? CLong {
            self.storeId = storeId
        }
        if let typeOrder = dictionary["type_order"] as? Int {
            self.typeOrder = typeOrder
        }
        if let currency = dictionary["currency"] as? String {
            self.currency = currency
        }
        if let paymentMethodReference = dictionary["payment_method_reference"] as? String {
            self.paymentMethodReference = paymentMethodReference
        }
        if let paymentReference = dictionary["payment_reference"] as? String {
            self.paymentReference = paymentReference
        }
        if let service = dictionary["service"] as? Int {
            self.service = service
        }
        if let store = dictionary["store"] as? [String: Any] {
            self.store = PmzStore(dictionary: store)
        }
    }
    
    func getJSONForPayment() -> [String: Any] {
        return [API.K.ParameterKey.amount: totalAmount!,
                API.K.ParameterKey.orderId: id!,
                API.K.ParameterKey.paymentMethodReference: paymentMethodReference!,
                API.K.ParameterKey.paymentReference: paymentReference!,
                API.K.ParameterKey.service: service!,
                API.K.ParameterKey.token: PaymentezSDK.shared.token!]
    }
    
    func getJSONForPlace() -> [String: Any] {
        return [API.K.ParameterKey.orderId: id!,
                API.K.ParameterKey.token: PaymentezSDK.shared.token!]
    }
    
    //TODO: ENCODE
    
    func getJSONForStartOrder() -> [String: Any] {
        var result = [API.K.ParameterKey.deliveryInstructions: deliveryInstructions ?? "",
                      API.K.ParameterKey.annotations: annotations ?? "",
                      API.K.ParameterKey.appOrderReference: appOrderReference ?? "",
                      API.K.ParameterKey.storeId: storeId ?? 0,
                      API.K.ParameterKey.typeOrder: typeOrder ?? 0,
                      API.K.ParameterKey.token: PaymentezSDK.shared.token!] as [String : Any]
        if buyer != nil {
            result = buyer!.addToParams(result)
        }
        if address != nil {
            result = address!.addToParams(result)
        }
        return result
    }
    
    public static func hardcoded() -> PmzOrder {
        if let dic = convertStringToDictionary(text: PmzOrder.json) {
            return PmzOrder(dictionary: dic)
        } else {
            return PmzOrder()
        }
    }
    
    public static func hardcodedForOrderStart() -> PmzOrder {
        if let dic = convertStringToDictionary(text: PmzOrder.jsonForOrderStart) {
            return PmzOrder(dictionary: dic)
        } else {
            return PmzOrder()
        }
    }
    
    static func convertStringToDictionary (text:String) -> [String: Any]? {
        do {
            let data: Data = text.data(using: String.Encoding.utf8)!
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            return nil
        }
    }
    
    func mergeData(_ oldOrder: PmzOrder) -> PmzOrder {
        if let items = items, let oldItems = oldOrder.items {
            for oldItem in oldItems {
                for newItem in items {
                    if let newProductId = newItem.productId, let oldProductId = oldItem.productId, newProductId == oldProductId {
                        newItem.imageUrl = oldItem.imageUrl
                    }
                }
            }
        }
        if let store = oldOrder.store {
            self.store = store
        }
        return self
    }
    
    static let json = "{\n" +
    "  \"id\": 8493,\n" +
    "  \"status\": 0,\n" +
    "  \"tax\": 0,\n" +
    "  \"items\": [\n" +
    "    {\n" +
    "      \"id\": 15053,\n" +
    "      \"tax\": 0,\n" +
    "      \"annotations\": \"sin servilletas\",\n" +
    "      \"status\": 0,\n" +
    "      \"image\":\"https://middleware-prod-paymentez.s3.amazonaws.com/Menus/Logos/poke.jpg\",\n" +
    "      \"configurations\": [\n" +
    "        {\n" +
    "          \"id\": 13015,\n" +
    "          \"annotations\": null,\n" +
    "          \"description\": \"Ajonjolí\",\n" +
    "          \"type\": 2,\n" +
    "          \"cost\": 1000,\n" +
    "          \"configuration_id\": 11520,\n" +
    "          \"discount\": null\n" +
    "        },\n" +
    "        {\n" +
    "          \"id\": 13016,\n" +
    "          \"annotations\": null,\n" +
    "          \"description\": \"Cubiertos\",\n" +
    "          \"type\": 2,\n" +
    "          \"cost\": 0,\n" +
    "          \"configuration_id\": 11494,\n" +
    "          \"discount\": null\n" +
    "        }\n" +
    "      ],\n" +
    "      \"total_amount\": 17000,\n" +
    "      \"unit_amount\": 16000,\n" +
    "      \"quantity\": 1,\n" +
    "      \"product_id\": 7351,\n" +
    "      \"product_name\": \"Ceviche\",\n" +
    "      \"discount\": null\n" +
    "    }\n" +
    "  ],\n" +
    "  \"buyer_email\": \"breyes@paymentez.com\",\n" +
    "  \"buyer_name\": \"Bruno Reyes\",\n" +
    "  \"buyer_phone\": \"3212000915\",\n" +
    "  \"buyer_fiscal_number\": \"1054092666\",\n" +
    "  \"user_reference\": \"f6dc275d-5e64-4127-bf5c-dbbfac02aacd\",\n" +
    "  \"order_app_reference\": \"test-1744\",\n" +
    "  \"confirmation_code\": null,\n" +
    "  \"table_reference\": null,\n" +
    "  \"delivery_date\": null,\n" +
    "  \"reserve_code\": null,\n" +
    "  \"date_placed\": null,\n" +
    "  \"date_started\": \"2020-09-17T10:48:24.000Z\",\n" +
    "  \"order_type\": 0,\n" +
    "  \"total_amount\": 17000,\n" +
    "  \"address_line1\": \"Calle 75 20C-81\",\n" +
    "  \"address_line2\": \"Calle 75 - 20C-81\",\n" +
    "  \"address_city\": \"Bogotá\",\n" +
    "  \"address_state\": \"DC\",\n" +
    "  \"address_zip\": \"00000\",\n" +
    "  \"address_country\": \"Colombia\",\n" +
    "  \"address_latitude\": 4.6568103,\n" +
    "  \"address_longitude\": -74.0561968,\n" +
    "  \"delivery_instructions\": \"Apto 206\",\n" +
    "  \"delivery_price\": 0,\n" +
    "  \"status_description\": null,\n" +
    "  \"store\": {\n" +
    "    \"id\": 97,\n" +
    "    \"name\": \"Spoleto Centro Chia\",\n" +
    "    \"address\": \"Avenida Pradilla 900 Este local 51\",\n" +
    "    \"lat\": 4.8471644,\n" +
    "    \"lon\": -74.0784931,\n" +
    "    \"country\": \"CO\",\n" +
    "    \"city\": \"Chía\",\n" +
    "    \"website\": null,\n" +
    "    \"phone\": null,\n" +
    "    \"image\": \"https://middleware-prod-paymentez.s3.us-east-1.amazonaws.com/Menus/Logos/generic-qr.png\",\n" +
    "    \"enable_pay_at_the_table_orders\": null,\n" +
    "    \"type\": 8,\n" +
    "    \"commerce_image\": \"https://middleware-paymentez.s3.amazonaws.com/Menus/Logos/spoleto.jpg\",\n" +
    "    \"commerce_id\": 51,\n" +
    "    \"commerce_fiscal_number\": null,\n" +
    "    \"subsidiary_id\": null,\n" +
    "    \"zip_code\": null,\n" +
    "    \"company_name\": null,\n" +
    "    \"status\": 1,\n" +
    "    \"commerce_paymentez_app_code\": null,\n" +
    "    \"internal_name\": null,\n" +
    "    \"commerce_name\": \"Spoleto\",\n" +
    "    \"show_stock\": true,\n" +
    "    \"print\": null,\n" +
    "    \"menu_id\": 56,\n" +
    "    \"delivery_price\": null,\n" +
    "    \"max_delivery_distance\": null,\n" +
    "    \"accept_delivery\": false,\n" +
    "    \"time_preparing\": 20,\n" +
    "    \"extra_payments_codes\": [\n" +
    "      {\n" +
    "        \"method_reference\": \"PAYMENTEZ\",\n" +
    "        \"description\": \"Pago con tarjeta\"\n" +
    "      },\n" +
    "      {\n" +
    "        \"method_reference\": \"DEBIT\",\n" +
    "        \"description\": \"Pago con datáfono o efectivo\"\n" +
    "      },\n" +
    "      {\n" +
    "        \"method_reference\": \"DISCOUNT\",\n" +
    "        \"description\": \"Descuento\"\n" +
    "      }\n" +
    "    ],\n" +
    "    \"server_app_code\": \"FALTA\",\n" +
    "    \"clien_app_code\": \"FALTA\",\n" +
    "    \"sponsor\": null,\n" +
    "    \"table_service_amount\": null,\n" +
    "    \"table_service_percentage\": null\n" +
    "  }\n" +
    "}";
    
    static let jsonForOrderStart = "{\n" +
    "    \"address_city\": \"Bogotá\",\n" +
    "    \"address_country\": \"Colombia\",\n" +
    "    \"address_latitude\": 4.6568103,\n" +
    "    \"address_line1\": \"Calle 75 20C-81\",\n" +
    "    \"address_line2\": \"Calle 75 - 20C-81\",\n" +
    "    \"address_longitude\": -74.0561968,\n" +
    "    \"address_state\": \"DC\",\n" +
    "    \"address_zip\": \"\",\n" +
    "    \"delivery_instructions\": \"Apto 206\",\n" +
    "    \"Annotations\": \"\",\n" +
    "    \"buyer_email\": \"breyes@paymentez.com\",\n" +
    "    \"buyer_fiscal_number\": \"1054092666\",\n" +
    "    \"buyer_name\": \"Bruno Reyes\",\n" +
    "    \"buyer_phone\": \"3212000915\",\n" +
    "    \"buyer_user_reference\": \"f6dc275d-5e64-4127-bf5c-dbbfac02aacd\",\n" +
    "    \"app_order_reference\": \"test-1744\",\n" +
    "    \"id_store\":120,\n" +
    "    \"session\": \"{{token}}\",\n" +
    "    \"type_order\": 0\n" +
    "}";
}
