import Foundation

public protocol PmzSearchCallback {
    func searchFinishedSuccessfully(order: PmzOrder)
    func searchFinishedWithError(error: PmzError)
    func searchCancelled()
}

public protocol PmzPayAndPlaceCallback {
    func payAndPlaceFinishedSuccessfully(order: PmzOrder)
    func payAndPlaceOnError(order: PmzOrder?, error: PmzError)
}

public protocol PmzGetStoresCallback {
    func getStoresOnSuccess(stores: [PmzStore])
    func getStoresOnError(error: PmzError)
}

public class PaymentezSDK {
    
    public static let shared: PaymentezSDK = PaymentezSDK()
    var navController: UINavigationController?
    var presentingVC: UIViewController?
    var session: PmzSession?
    var style: PmzStyle?
    var token: String?
    var buyer: PmzBuyer?
    var appOrderReference: String?
    
    var searchCallback: PmzSearchCallback?
    var paymentCheckerCallback: PmzPayAndPlaceCallback?
    var getStoresCallback: PmzGetStoresCallback?
    
    private init(){}
    
    public func initialize(appCode: String, appKey: String) {
        session = PmzSession(appCode: appCode, appKey: appKey)
        style = PmzStyle()
    }
    
    public func setStyle(style: PmzStyle) -> PaymentezSDK {
        self.style = style
        return self
    }
    
    func isInitialized() -> Bool {
        if session != nil {
            return true
        } else {
            fatalError("PaymentezSDK: not initialized")
        }
    }
    
    func isBuyerWellInitialized(_ buyer: PmzBuyer) -> Bool {
        if buyer.email != nil && buyer.email! != ""
            && buyer.fiscalNumber != nil && buyer.fiscalNumber! != ""
            && buyer.name != nil && buyer.name! != ""
            && buyer.phone != nil && buyer.phone! != ""
            && buyer.userReference != nil && buyer.userReference! != "" {
            return true
        } else {
            fatalError("PaymentezSDK: PmzBuyer malformed")
        }
    }
    
    func isAppOrderReferenceUsable(_ appOrderReference: String) -> Bool {
        if appOrderReference != "" {
            return true
        } else {
            fatalError("PaymentezSDK: appOrderReference is empty")
        }
    }
    
    public func startSearch(navigationController: UINavigationController, buyer: PmzBuyer, appOrderReference: String, callback: PmzSearchCallback) {
        if isInitialized() && isBuyerWellInitialized(buyer) && isAppOrderReferenceUsable(appOrderReference){
            self.buyer = buyer
            self.appOrderReference = appOrderReference
            searchCallback = callback
            navController = navigationController
            navigationController.isNavigationBarHidden = true
            presentingVC = navigationController.viewControllers.last
            let firstController = PmzStoresViewController.init()
            navigationController.pushViewController(firstController, animated: true)
        }
    }
    
    public func startSearch(navigationController: UINavigationController, buyer: PmzBuyer, appOrderReference: String, storeId: CLong, callback: PmzSearchCallback) {
        if isInitialized() && isBuyerWellInitialized(buyer) && isAppOrderReferenceUsable(appOrderReference) {
            self.buyer = buyer
            self.appOrderReference = appOrderReference
            searchCallback = callback
            navController = navigationController
            navigationController.isNavigationBarHidden = true
            presentingVC = navigationController.viewControllers.last
            let secondController = PmzMenuViewController.init()
            secondController.storeId = storeId
            navigationController.pushViewController(secondController, animated: true)
        }
    }
    
    public func showSummary(navigationController: UINavigationController, order: PmzOrder, callback: PmzSearchCallback) {
        if(isInitialized()) {
            searchCallback = callback
            navController = navigationController
            navigationController.isNavigationBarHidden = true
            presentingVC = navigationController.viewControllers.last
            let summaryController = PmzSummaryViewController.init()
            summaryController.order = order
            navigationController.pushViewController(summaryController, animated: true)
        }
    }
    
    public func getStores(filter: String?, callback: PmzGetStoresCallback) {
        if isInitialized() {
            if token != nil {
                doGetStores(filter: filter, callback: callback)
            } else {
                API.sharedInstance.startSession(session: PaymentezSDK.shared.session!, callback: { [weak self] (token) in
                    guard let self = self else { return }
                    PaymentezSDK.shared.token = token
                    self.doGetStores(filter: filter, callback: callback)
                    }, failure: { (error) in
                        callback.getStoresOnError(error: error)
                })
            }
        }
    }
    
    func doGetStores(filter: String?, callback: PmzGetStoresCallback) {
        self.getStoresCallback = callback
        API.sharedInstance.getStores(callback: { (stores) in
            callback.getStoresOnSuccess(stores: stores)
            }, failure: { (error) in
                callback.getStoresOnError(error: error)
        })
    }
    
    public func startPayAndPlace(navigationController: UINavigationController, order: PmzOrder, paymentData: PmzPaymentData, callback: PmzPayAndPlaceCallback) {
        if isInitialized() {
            paymentCheckerCallback = callback
            let payAndPlace = PmzPayAndPlaceViewController.init()
            payAndPlace.paymentData = paymentData
            startPayPlaceGeneric(navigationController: navigationController, vc: payAndPlace, order: order)
        }
    }
    
    public func startPayAndPlace(navigationController: UINavigationController, order: PmzOrder, paymentData: PmzPaymentData, skipSummary: Bool, callback: PmzPayAndPlaceCallback) {
        if isInitialized() {
            paymentCheckerCallback = callback
            let payAndPlace = PmzPayAndPlaceViewController.init()
            payAndPlace.paymentData = paymentData
            payAndPlace.skipSummary = skipSummary
            startPayPlaceGeneric(navigationController: navigationController, vc: payAndPlace, order: order)
        }
    }
    
    public func startPayAndPlace(navigationController: UINavigationController, order: PmzOrder, paymentsData: [PmzPaymentData], callback: PmzPayAndPlaceCallback) {
        if isInitialized() {
            paymentCheckerCallback = callback
            let payAndPlace = PmzPayAndPlaceViewController.init()
            payAndPlace.paymentsData = paymentsData
            startPayPlaceGeneric(navigationController: navigationController, vc: payAndPlace, order: order)
        }
    }
    
    public func startPayAndPlace(navigationController: UINavigationController, order: PmzOrder, paymentsData: [PmzPaymentData], skipSummary: Bool, callback: PmzPayAndPlaceCallback) {
        if isInitialized() {
            paymentCheckerCallback = callback
            let payAndPlace = PmzPayAndPlaceViewController.init()
            payAndPlace.skipSummary = skipSummary
            payAndPlace.paymentsData = paymentsData
            startPayPlaceGeneric(navigationController: navigationController, vc: payAndPlace, order: order)
        }
    }
    
    func startPayPlaceGeneric(navigationController: UINavigationController, vc: PmzPayAndPlaceViewController, order: PmzOrder) {
        vc.order = order
        navController = navigationController
        navigationController.isNavigationBarHidden = true
        presentingVC = navigationController.viewControllers.last
        navigationController.pushViewController(vc, animated: true)
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
        goBackToHostApp()
        searchCallback?.searchCancelled()
        searchCallback = nil
    }
    
    func onSearchFinished(order: PmzOrder) {
        goBackToHostApp()
        searchCallback?.searchFinishedSuccessfully(order: order)
        searchCallback = nil
    }
    
    func onPaymentCheckingFinished(order: PmzOrder) {
        goBackToHostApp()
        paymentCheckerCallback?.payAndPlaceFinishedSuccessfully(order: PmzOrder())
        paymentCheckerCallback = nil
    }
    
    func onPaymentCheckingError(order: PmzOrder, error: PmzError) {
        goBackToHostApp()
        paymentCheckerCallback?.payAndPlaceOnError(order: order, error: error)
        paymentCheckerCallback = nil
    }
    
    private func goBackToHostApp() {
        if(presentingVC != nil) {
            navController?.popToViewController(presentingVC!, animated: true)
        } else {
            navController?.popToRootViewController(animated: true)
        }
    }
    
    public func goBackWithServiceError() {
        goBackToHostApp()
        if(paymentCheckerCallback != nil) {
            paymentCheckerCallback?.payAndPlaceOnError(order: nil, error: PmzError(PmzError.SERVICE_ERROR))
            paymentCheckerCallback = nil
        }
        if(searchCallback != nil) {
            searchCallback?.searchFinishedWithError(error: PmzError(PmzError.SERVICE_ERROR))
            searchCallback = nil
        }
    }
}
