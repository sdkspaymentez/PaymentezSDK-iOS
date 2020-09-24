//
//  PaymentezSDK.swift
//  PaymentezSDK
//
//  Created by Fennoma on 11/09/2020.
//

import Foundation

public protocol PmzSearchCallback {
    func searchFinishedSuccessfully(order: PmzOrder)
    func searchCancelled()
}

public protocol PmzPaymentCheckerCallback {
    func paymentCheckingFinishedSuccessfully(order: PmzOrder)
    func paymentCheckingOnError(order: PmzOrder, error: PmzError)
}

public class PaymentezSDK {
    
    public static let shared: PaymentezSDK = PaymentezSDK()
    var navController: UINavigationController?
    var presentingVC: UIViewController?
    
    var backgroundColor: UIColor?
    var textColor: UIColor?
    var buttonBackgroundColor: UIColor?
    var buttonTextColor: UIColor?
    var searchCallback: PmzSearchCallback?
    var paymentCheckerCallback: PmzPaymentCheckerCallback?
    
    private init(){}
    
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
    
    public func startSearch(navigationController: UINavigationController, storeId: CLong? = nil, callback: PmzSearchCallback) {
        searchCallback = callback
        navController = navigationController
        navigationController.isNavigationBarHidden = true
        presentingVC = navigationController.viewControllers.last
        if storeId != nil {
            let secondController = SecondController.init()
            secondController.storeId = storeId
            navigationController.pushViewController(secondController, animated: true)
        } else {
            let firstController = FirstController.init()
            navigationController.pushViewController(firstController, animated: true)
        }
    }
    
    public func startPaymentChecking(order: PmzOrder, navigationController: UINavigationController, callback: PmzPaymentCheckerCallback) {
        paymentCheckerCallback = callback
        let paymentChecker = PaymentCheckerViewController.init()
        paymentChecker.order = order
        navController = navigationController
        navigationController.isNavigationBarHidden = true
        presentingVC = navigationController.viewControllers.last
        navigationController.pushViewController(paymentChecker, animated: true)
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
    
    func onPaymentCheckingFinished(order: PmzOrder) {
        if(presentingVC != nil) {
            navController?.popToViewController(presentingVC!, animated: true)
        } else {
            navController?.popToRootViewController(animated: true)
        }
        paymentCheckerCallback?.paymentCheckingFinishedSuccessfully(order: PmzOrder())
    }
    
    func onPaymentCheckingError(order: PmzOrder, error: PmzError) {
        if(presentingVC != nil) {
            navController?.popToViewController(presentingVC!, animated: true)
        } else {
            navController?.popToRootViewController(animated: true)
        }
        paymentCheckerCallback?.paymentCheckingOnError(order: order, error: error)
    }
}
