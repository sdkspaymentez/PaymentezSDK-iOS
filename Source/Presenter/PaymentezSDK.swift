//
//  PaymentezSDK.swift
//  PaymentezSDK
//
//  Created by Fennoma on 11/09/2020.
//

import Foundation

public protocol PaymentezCallback {
    func flowFinishedSuccessfully()
    func flowCancelled()
}

public class PaymentezSDK {
    
    public static let shared: PaymentezSDK = PaymentezSDK()
    var navController: UINavigationController?
    var presentingVC: UIViewController?
    
    var backgroundColor: UIColor?
    var textColor: UIColor?
    var buttonBackgroundColor: UIColor?
    var callback: PaymentezCallback?
    
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
    
    public func setCallback(callback: PaymentezCallback) -> PaymentezSDK {
        self.callback = callback
        return self
    }
    
    public func startSDK(navigationController: UINavigationController) {
        let firstController = FirstController.init()
        navController = navigationController
        navigationController.isNavigationBarHidden = true
        presentingVC = navigationController.viewControllers.last
        navigationController.pushViewController(firstController, animated: true)
    }
    
    func pushVC(vc: UIViewController) {
        if(navController != nil) {
            navController!.pushViewController(vc, animated: true)
        }
    }
    
    func getBundle() -> Bundle? {
        return Bundle(for: PaymentezSDK.self)
    }
    
    func onFlowCancelled() {
        callback?.flowCancelled()
    }
    
    func onFlowFinished() {
        if(presentingVC != nil) {
            navController?.popToViewController(presentingVC!, animated: true)
        } else {
            navController?.popToRootViewController(animated: true)
        }
        callback?.flowFinishedSuccessfully()
    }
}
