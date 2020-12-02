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

public class PaymentezSDK {
    
    public static let shared: PaymentezSDK = PaymentezSDK()
    var navController: UINavigationController?
    var presentingVC: UIViewController?
    var session: PmzSession?
    var token: String?
    
    var backgroundColor: UIColor?
    var textColor: UIColor?
    var buttonBackgroundColor: UIColor?
    var buttonTextColor: UIColor?
    var searchCallback: PmzSearchCallback?
    var paymentCheckerCallback: PmzPayAndPlaceCallback?
    
    private init(){}
    
    public func initialize(appCode: String, appKey: String) {
        session = PmzSession(appCode: appCode, appKey: appKey)
    }
    
    public func setBackgroundColor(backgroundColor: UIColor) -> PaymentezSDK {
        self.backgroundColor = backgroundColor
        return self
    }
    
    public func setTextColor(textColor: UIColor) -> PaymentezSDK {
        self.textColor = textColor
        return self
    }
    
    public func setButtonBackgroundColor(buttonBackgroundColor: UIColor) -> PaymentezSDK {
        self.buttonBackgroundColor = buttonBackgroundColor
        return self
    }
    
    public func setButtonTextColor(buttonTextColor: UIColor) -> PaymentezSDK {
        self.buttonTextColor = buttonTextColor
        return self
    }
    
    func isInitialized() -> Bool {
        if session != nil {
            return true
        } else {
            fatalError("PaymentezSDK not initialized")
        }
    }
    
    public func startSearch(navigationController: UINavigationController, callback: PmzSearchCallback) {
        if isInitialized() {
            searchCallback = callback
            navController = navigationController
            navigationController.isNavigationBarHidden = true
            presentingVC = navigationController.viewControllers.last
            let firstController = PmzStoresViewController.init()
            navigationController.pushViewController(firstController, animated: true)
        }
    }
    
    public func startSearch(navigationController: UINavigationController, storeId: CLong, callback: PmzSearchCallback) {
        if isInitialized() {
            searchCallback = callback
            navController = navigationController
            navigationController.isNavigationBarHidden = true
            presentingVC = navigationController.viewControllers.last
            let secondController = PmzMenuViewController.init()
            secondController.storeId = storeId
            navigationController.pushViewController(secondController, animated: true)
        }
    }
    
    public func startPayAndPlace(order: PmzOrder, paymentReference: String, navigationController: UINavigationController, callback: PmzPayAndPlaceCallback) {
        if isInitialized() {
            paymentCheckerCallback = callback
            let payAndPlace = PmzPayAndPlaceViewController.init()
            payAndPlace.order = order
            payAndPlace.paymentReference = paymentReference
            navController = navigationController
            navigationController.isNavigationBarHidden = true
            presentingVC = navigationController.viewControllers.last
            navigationController.pushViewController(payAndPlace, animated: true)
        }
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
    
    func onSearchFinished() {
        goBackToHostApp()
        searchCallback?.searchFinishedSuccessfully(order: PmzOrder())
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
