//
//  SummaryFooterView.swift
//  Alamofire
//
//  Created by Fennoma on 17/12/2020.
//

import Foundation

class SummaryFooterView: UIView {
    
    @IBOutlet var totalPaymentTitle: UILabel!
    @IBOutlet var totalPayment: UILabel!
    
    func initialize() {
        if let textColor = PaymentezSDK.shared.style?.textColor {
            totalPaymentTitle.textColor = textColor
            totalPayment.textColor = textColor
        }
    }
    
    func setPrice(price: Double?) {
        totalPayment.text = CurrencyUtils.getPrice(price)
    }
}
