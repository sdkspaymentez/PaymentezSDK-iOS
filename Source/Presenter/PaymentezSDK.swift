import Foundation

public protocol PmzSearchCallback {
    func searchFinishedSuccessfully(order: PmzOrder)
    func searchCancelled()
}

public protocol PmzPayAndPlaceCallback {
    func payAndPlaceFinishedSuccessfully(order: PmzOrder)
    func payAndPlaceOnError(order: PmzOrder, error: PmzError)
}

public protocol PmzPayAndPlaceMultipleOrdersCallback {
    func payAndPlaceFinishedSuccessfully(orders: [PmzOrder])
    func payAndPlaceOnError(orders: [PmzOrder], error: PmzError)
}

public protocol PmzGetStoresCallback {
    func gotStores(stores: [PmzStore])
    func gettingStoresFailed()
}

public class PaymentezSDK {
    
    public static let shared: PaymentezSDK = PaymentezSDK()
    var navController: UINavigationController?
    var presentingVC: UIViewController?
    var session: PmzSession?
    var token: String?
    
    var style: PmzStyle?
    var searchCallback: PmzSearchCallback?
    var paymentCheckerCallback: PmzPayAndPlaceCallback?
    var paymentCheckerMultipleOrdersCallback: PmzPayAndPlaceMultipleOrdersCallback?
    
    private init(){}
    
    public func setStyle(style: PmzStyle) -> PaymentezSDK {
        self.style = style
        return self
    }
    
    public func startSearch(navigationController: UINavigationController, buyer: PmzBuyer, appOrderReference: String, callback: PmzSearchCallback) {
        if isInitialized() && isBuyerUsable(buyer) && isAppOrderReferenceUsable(appOrderReference){
            searchCallback = callback
            navController = navigationController
            navigationController.isNavigationBarHidden = true
            presentingVC = navigationController.viewControllers.last
            let firstController = PmzStoresViewController.init()
            navigationController.pushViewController(firstController, animated: true)
        }
    }
    
    public func startSearch(navigationController: UINavigationController, buyer: PmzBuyer, appOrderReference: String, searchStoresFilter: String, callback: PmzSearchCallback) {
        if isInitialized() && isBuyerUsable(buyer) && isAppOrderReferenceUsable(appOrderReference){
            searchCallback = callback
            navController = navigationController
            navigationController.isNavigationBarHidden = true
            presentingVC = navigationController.viewControllers.last
            let firstController = PmzStoresViewController.init()
            firstController.searchFilter = searchStoresFilter
            navigationController.pushViewController(firstController, animated: true)
        }
    }
    
    public func startSearch(navigationController: UINavigationController, buyer: PmzBuyer, appOrderReference: String, storeId: CLong, callback: PmzSearchCallback) {
        if isInitialized() && isBuyerUsable(buyer) && isAppOrderReferenceUsable(appOrderReference) {
            searchCallback = callback
            navController = navigationController
            navigationController.isNavigationBarHidden = true
            presentingVC = navigationController.viewControllers.last
            let secondController = PmzMenuViewController.init()
            secondController.storeId = storeId
            navigationController.pushViewController(secondController, animated: true)
        }
    }
    
    public func showSummary(navigationController: UINavigationController, appOrderReference: String, order: PmzOrder, callback: PmzSearchCallback) {
        if isInitialized() && isAppOrderReferenceUsable(appOrderReference){
            searchCallback = callback
            navController = navigationController
            navigationController.isNavigationBarHidden = true
            presentingVC = navigationController.viewControllers.last
            let summaryController = PmzSummaryViewController.init()
            summaryController.order = order
            summaryController.justSummary = true
            navigationController.pushViewController(summaryController, animated: true)
        }
    }
    
    public func startPayAndPlace(navigationController: UINavigationController, order: PmzOrder, paymentData: PmzPaymentData, skipSummary: Bool = false, callback: PmzPayAndPlaceCallback) {
        if isInitialized() && isPaymentDataUsable(paymentData) {
            paymentCheckerCallback = callback
            let payAndPlace = PmzPayAndPlaceViewController.init()
            payAndPlace.order = order
            payAndPlace.paymentData = paymentData
            payAndPlace.skipSummary = skipSummary
            navController = navigationController
            navigationController.isNavigationBarHidden = true
            presentingVC = navigationController.viewControllers.last
            navigationController.pushViewController(payAndPlace, animated: true)
        }
    }
    
    public func startPayAndPlace(navigationController: UINavigationController, orders: [PmzOrder], paymentData: PmzPaymentData, skipSummary: Bool = false, callback: PmzPayAndPlaceMultipleOrdersCallback) {
        if isInitialized() && isPaymentDataUsable(paymentData) {
            paymentCheckerMultipleOrdersCallback = callback
            let payAndPlace = PmzPayAndPlaceViewController.init()
            payAndPlace.orders = orders
            payAndPlace.paymentData = paymentData
            payAndPlace.skipSummary = skipSummary
            navController = navigationController
            navigationController.isNavigationBarHidden = true
            presentingVC = navigationController.viewControllers.last
            navigationController.pushViewController(payAndPlace, animated: true)
        }
    }
    
    public func getStores(callback: PmzGetStoresCallback) {
        callback.gotStores(stores: PmzStore.hardcoded())
    }
    
    public func initialize(appCode: String, appKey: String) {
        session = PmzSession(appCode: appCode, appKey: appKey)
    }
    
    func isInitialized() -> Bool {
        if session != nil {
            return true
        }
        fatalError("PaymentezSDK: not initialized")
    }
    
    func isBuyerUsable(_ buyer: PmzBuyer) -> Bool {
        if buyer.email != nil && buyer.email != ""
            && buyer.name != nil && buyer.name != ""
            && buyer.phone != nil && buyer.phone != ""
            && buyer.fiscalNumber != nil && buyer.fiscalNumber != ""
            && buyer.userReference != nil && buyer.userReference != "" {
            return true
        }
        fatalError("PaymentezSDK: PmzBuyer malformed")
    }
    
    func isAppOrderReferenceUsable(_ appOrderReference: String) -> Bool {
        if appOrderReference != "" {
            return true
        }
        fatalError("PaymentezSDK: appOrderReference is empty")
    }
    
    func isPaymentDataUsable(_ paymentData: PmzPaymentData) -> Bool {
        if paymentData.amount != nil
            && paymentData.service != nil
            && paymentData.paymentReference != nil && paymentData.paymentReference != ""
            && paymentData.paymentMethodReference != nil && paymentData.paymentMethodReference != "" {
            return true
        }
        fatalError("PaymentezSDK: PmzBuyer malformed")
    }
    
    func pushVC(vc: UIViewController) {
        if(navController != nil) {
            navController!.pushViewController(vc, animated: true)
        }
    }
    
    func getBundle() -> Bundle? {
        return Bundle(for: PaymentezSDK.self)
    }
    
    func onSearchCancelled() {
        searchCallback?.searchCancelled()
    }
    
    func onSearchFinished() {
        if(presentingVC != nil) {
            navController?.popToViewController(presentingVC!, animated: true)
        } else {
            navController?.popToRootViewController(animated: true)
        }
        searchCallback?.searchFinishedSuccessfully(order: PmzOrder())
    }
    
    func onPaymentCheckingFinished(order: PmzOrder? = nil, orders: [PmzOrder]? = nil) {
        if(presentingVC != nil) {
            navController?.popToViewController(presentingVC!, animated: true)
        } else {
            navController?.popToRootViewController(animated: true)
        }
        if order != nil {
            paymentCheckerCallback?.payAndPlaceFinishedSuccessfully(order: PmzOrder())
        } else if orders != nil {
            paymentCheckerMultipleOrdersCallback?.payAndPlaceFinishedSuccessfully(orders: orders!)
        }
    }
    
    func onPaymentCheckingError(order: PmzOrder? = nil, orders: [PmzOrder]? = nil, error: PmzError) {
        if(presentingVC != nil) {
            navController?.popToViewController(presentingVC!, animated: true)
        } else {
            navController?.popToRootViewController(animated: true)
        }
        if order != nil {
            paymentCheckerCallback?.payAndPlaceOnError(order: order!, error: error)
        } else if orders != nil {
            paymentCheckerMultipleOrdersCallback?.payAndPlaceOnError(orders: orders!, error: error)
        }
    }
    
}
