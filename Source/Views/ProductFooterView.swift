//
//  ProductFooterView.swift
//  Alamofire
//
//  Created by Fennoma on 15/12/2020.
//

import Foundation

protocol ProductFooterDelegate {
    func onQuantityChanged(quantity: Int)
}

class ProductFooterView: UIView {
    @IBOutlet var quantityTitle: UILabel!
    @IBOutlet var totalTitle: UILabel!
    @IBOutlet var totalPrice: UILabel!
    @IBOutlet var amount: UILabel!
    
    @IBOutlet var minusImage: UIImageView!
    @IBOutlet var plusImage: UIImageView!
    @IBOutlet var minusButton: UIView!
    @IBOutlet var plusButton: UIView!
    
    var currentPrice: Double = 0
    var counter: Int = 1
    
    var delegate: ProductFooterDelegate?
    
    func initialize() {
        minusButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapMinusButton)))
        plusButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapPlusButton)))
        if let buttonColor = PaymentezSDK.shared.style?.buttonBackgroundColor {
            minusImage.tintColor = buttonColor
            plusImage.tintColor = buttonColor
        }
        if let textColor = PaymentezSDK.shared.style?.textColor {
            quantityTitle.textColor = textColor
            totalPrice.textColor = textColor
            totalTitle.textColor = textColor
            amount.textColor = textColor
        }
    }
    
    @objc func didTapPlusButton() {
        counter += 1
        amount.text = String(counter)
        refresh()
    }
    
    @objc func didTapMinusButton() {
        if counter > 1 {
            counter -= 1
            amount.text = String(counter)
            refresh()
        }
    }
    
    func setCurrentPrice(price: Double) {
        self.currentPrice = price
        if delegate != nil {
            delegate?.onQuantityChanged(quantity: counter)
        }
        refresh()
    }
    
    func refresh() {
        totalPrice.text = CurrencyUtils.getPrice(currentPrice * Double(counter))
    }
}
