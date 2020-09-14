//
//  PaymentezViewController.swift
//  PaymentezSDK
//
//  Created by Fennoma on 11/09/2020.
//

import Foundation

class PaymentezViewController: UIViewController {
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headerBar: UIView!
    @IBOutlet var mainText: UILabel!
    @IBOutlet var headerTitle: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet var nextButtonBackground: UIView!
    @IBOutlet var nextButtonTextColor: UILabel!
    @IBOutlet var backTextColor: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPropperColors()
        //headerBar.addBottomShadow()
    }
    
    func setPropperColors() {
        if let bgColor = PaymentezSDK.shared.backgroundColor {
            mainView.backgroundColor = bgColor
        }
        if let buttonColor = PaymentezSDK.shared.buttonBackgroundColor {
            headerBar.backgroundColor = buttonColor
            nextButtonBackground.backgroundColor = buttonColor
        }
        if let textColor = PaymentezSDK.shared.textColor {
            mainText.textColor = textColor
            headerTitle.textColor = textColor
            backButton.imageView?.tintColor = textColor
            nextButtonTextColor.textColor = textColor
            backTextColor.textColor = textColor
        }
    }
}
