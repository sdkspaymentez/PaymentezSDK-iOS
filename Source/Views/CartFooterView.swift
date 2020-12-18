//
//  CartFooterView.swift
//  Alamofire
//
//  Created by Fennoma on 17/12/2020.
//

import Foundation

class CartFooterView: UIView, UITextViewDelegate {
    
    static let placeholder = "Agregar comentarios del pedido"
    
    @IBOutlet var totalPaymentTitle: UILabel!
    @IBOutlet var totalPayment: UILabel!
    @IBOutlet var comment: UITextView!
    
    func initialize() {
        if let textColor = PaymentezSDK.shared.style?.textColor {
            totalPaymentTitle.textColor = textColor
            totalPayment.textColor = textColor
        }
        comment.text = CartFooterView.placeholder
        comment.delegate = self
    }
    
    func setPrice(price: Double?) {
        totalPayment.text = CurrencyUtils.getPrice(price)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if comment.text == CartFooterView.placeholder {
            comment.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if comment.text.isEmpty {
            comment.text = CartFooterView.placeholder
        }
    }

    func getComment() -> String {
        var result = ""
        if comment.text != CartFooterView.placeholder {
            result = comment.text
        }
        return result
    }
}
