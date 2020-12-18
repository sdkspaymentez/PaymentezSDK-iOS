import Foundation

class API {
    
    static let sharedInstance = API()
    
    struct K {
        struct ProductionServer {
            static let BASE_URL = "https://middleware-stg.paymentez.com/"
        }
        
        struct Path {
            static let START_SESSION = "start-session"
            static let GET_STORES = "store/list"
            static let GET_MENU = "store/get-menu"
            static let GET_ORDER = "order/get-order"
            static let GET_CAPACITIES = "store/capacity"
            static let POST_PAY_ORDER = "payment/pay-order"
            static let POST_PLACE_ORDER = "order/place-order"
            static let START_ORDER = "order/start-order"
            static let DELETE_ITEM = "order/delete-item"
            static let ADD_ITEM_WITH_CONFIGURATIONS = "order/add-item-w-configuration"
        }
        
        struct ParameterKey {
            static let appCode = "app_code"
            static let appKey = "app_key"
            static let token = "session"
            
            static let storeId = "id_store"
            static let orderId = "id_order"
            static let productId = "id_product"
            static let idOrderItem = "id_order_item"
            
            static let amount = "amount"
            static let paymentMethodReference = "payment_method_reference"
            static let paymentReference = "payment_reference"
            static let service = "service"
            
            static let annotations = "annotations"
            static let quantity = "quantity"
            static let configurations = "configurations"
            static let configurationId = "id_configuration"
            
            static let deliveryInstructions = "delivery_instructions"
            static let appOrderReference = "app_order_reference"
            static let typeOrder = "type_order"
        }
        
        struct HTTPHeaderField {
            static let authentication = "Authorization"
            static let contentType = "Content-Type"
            static let acceptType = "Accept"
            static let acceptEncoding = "Accept-Encoding"
        }
        
        struct ContentType {
            static let json = "application/json"
            static let formUrlEncoded = "application/x-www-form-urlencoded"
        }
        
        struct HTTPMethod {
            static let post = "POST"
            static let get = "GET"
            static let put = "PUT"
        }
        
        struct ServiceGenericAnswers {
            static let messageOk = "OK"
            static let statusOk = "00"
        }
    }
    
    func startSession(session: PmzSession, callback: @escaping (String) -> Void, failure: @escaping ((_ error: PmzError) -> Void)) {

        let request = getJSONRequest(path: K.Path.START_SESSION, session.getJSONParams())
        
        doRequest(request: request, callback: { (token: String) in
                callback(token)
            }, failure: failure)
    }
    
    func startOrder(order: PmzOrder, callback: @escaping (PmzOrder) -> Void, failure: @escaping ((_ error: PmzError) -> Void)) {

        let request = getJSONRequest(path: K.Path.START_ORDER, order.getJSONForStartOrder())
        
        doRequest(request: request, callback: { (json: [String: Any]) in
                callback(PmzOrder(dictionary: json))
            }, failure: failure)
    }
    
    func pay(paymentData: PmzPaymentData, orderId: CLong, callback: @escaping (PmzOrder) -> Void, failure: @escaping ((_ error: PmzError) -> Void)) {

        let request = getJSONRequest(path: K.Path.POST_PAY_ORDER, paymentData.getJSONForPayment(orderId: orderId))
        
        doRequest(request: request, callback: { (json: [String: Any]) in
                callback(PmzOrder(dictionary: json))
            }, failure: failure)
    }
    
    func placeOrder(order: PmzOrder, callback: @escaping (PmzOrder) -> Void, failure: @escaping ((_ error: PmzError) -> Void)) {

        let request = getJSONRequest(path: K.Path.POST_PLACE_ORDER, order.getJSONForPlace())
        
        doRequest(request: request, callback: { (json: [String: Any]) in
            callback(PmzOrder(dictionary: json))
        }, failure: failure)
    }
    
    func addItemWithConfigurations(item: PmzItem, callback: @escaping (PmzOrder) -> Void, failure: @escaping ((_ error: PmzError) -> Void)) {

        let request = getJSONRequest(path: K.Path.ADD_ITEM_WITH_CONFIGURATIONS, item.getJSONWithConf())
        
        doRequest(request: request, callback: { (json: [String: Any]) in
                callback(PmzOrder(dictionary: json))
            }, failure: failure)
    }
    
    func deleteItem(item: PmzItem, callback: @escaping (PmzOrder) -> Void, failure: @escaping ((_ error: PmzError) -> Void)) {

        let request = getJSONRequest(path: K.Path.DELETE_ITEM, item.getJSONForDelete())
        
        doRequest(request: request, callback: { (json: [String: Any]) in
                callback(PmzOrder(dictionary: json))
            }, failure: failure)
    }
    
    func getStores(callback: @escaping ([PmzStore]) -> Void, failure: @escaping ((_ error: PmzError) -> Void)) {

        let request = getGetRequest(path: K.Path.GET_STORES, appendToken: true)
        
        doRequest(request: request, callback: { (json: NSArray) in
                let stores = json.compactMap {
                    PmzStore(dictionary: $0 as! [String: Any])
                }
                callback(stores)
            }, failure: failure)
    }
    
    func getMenu(storeId: CLong, callback: @escaping (PmzMenu) -> Void, failure: @escaping ((_ error: PmzError) -> Void)) {

        let request = getGetRequest(path: K.Path.GET_MENU, appendToken: true, args: K.ParameterKey.storeId, String(storeId))
        
        doRequest(request: request, callback: { (json: [String: Any]) in
                callback(PmzMenu(dictionary: json))
            }, failure: failure)
    }
    
    func getOrder(orderId: CLong, callback: @escaping (PmzOrder) -> Void, failure: @escaping ((_ error: PmzError) -> Void)) {

        let request = getGetRequest(path: K.Path.GET_ORDER, appendToken: true, args: K.ParameterKey.orderId, String(orderId))
        
        doRequest(request: request, callback: { (json: [String: Any]) in
                callback(PmzOrder(dictionary: json))
            }, failure: failure)
    }
    
    func getCapacities(callback: @escaping (PmzOrder) -> Void, failure: @escaping ((_ error: PmzError) -> Void)) {

        let request = getGetRequest(path: K.Path.GET_CAPACITIES, appendToken: true)
        
        doRequest(request: request, callback: { (json: [String: Any]) in
                callback(PmzOrder(dictionary: json))
            }, failure: failure)
    }
    
    func getGetRequest(path: String, appendToken: Bool = false, args: String...) -> URLRequest {
        var finalPath: String = ""
        if appendToken {
             finalPath = path + "?session=" + PaymentezSDK.shared.token!
            if(args.count > 0) {
                finalPath += "&"
            }
        } else {
            finalPath = path
            if(args.count > 0) {
                finalPath += "?"
            }
        }
        if args.count % 2 != 0 {
            fatalError("Invalid amount of parameters")
        }
        if args.count > 0 {
            for i in 0...args.count - 1 {
                if i == 0 {
                   finalPath += args[0]
                } else if i % 2 == 0 {
                    finalPath += "&" + args[i]
                } else {
                    finalPath += "=" + args[i]
                }
            }
        }
        
        var request = URLRequest(url: getUrl(path: finalPath))
        request.httpMethod = K.HTTPMethod.get
        return request
    }
    
    
    func getJSONRequest(path: String, _ parameters: [String: Any]) -> URLRequest {
        let url = getUrl(path: path)
        
        var request = URLRequest(url: url)
        request.httpMethod = K.HTTPMethod.post

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        request.addValue(K.ContentType.json, forHTTPHeaderField: K.HTTPHeaderField.contentType)
        request.addValue(K.ContentType.json, forHTTPHeaderField: K.HTTPHeaderField.acceptType)
        
        return request
    }
    
    func doRequest<T>(request: URLRequest, callback: @escaping (T) -> Void, failure: @escaping ((_ error: PmzError) -> Void)) {
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    failure(PmzError())
                    return
                }
                guard let data = data else {
                    failure(PmzError())
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        
                        if let error = json["error"] as? String {
                            if let message = json["message"] as? String {
                                failure(PmzError(error, message))
                            } else {
                                failure(PmzError(error))
                            }
                        } else if let status = json["status"] as? String, let statusMessage = json["status_msg"] as? String, status == K.ServiceGenericAnswers.statusOk && statusMessage == K.ServiceGenericAnswers.messageOk {
                            callback(json["data"] as! T)
                        } else {
                            failure(PmzError())
                        }
                    }

                } catch let error {
                    failure(PmzError(error.localizedDescription))
                }
            }
        })
        task.resume()
    }
    
    func getUrl(path: String) -> URL {
        return URL(string: K.ProductionServer.BASE_URL + path)!
    }
}
