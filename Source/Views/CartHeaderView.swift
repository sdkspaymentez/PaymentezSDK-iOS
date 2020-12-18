//
//  CartHeaderView.swift
//  Alamofire
//
//  Created by Fennoma on 16/12/2020.
//

import Foundation

protocol CartHeaderDelegate {
    func onKeepBuyingPressed()
}

class CartHeaderView: UIView {
    
    @IBOutlet var storeName: UILabel!
    @IBOutlet var storeDesc: UILabel!
    @IBOutlet var storeLogo: UIImageView!
    @IBOutlet var keepBuyingButton: UIView!
    @IBOutlet var keepBuyingText: UILabel!
    @IBOutlet var cartTitle: UILabel!
    
    var delegate: CartHeaderDelegate?
    
    func configure(store: PmzStore?) {
        if let store = store {
            storeName.text = store.name
            storeDesc.text = store.commerceName
            PmzImageUtils.loadImage(store.imageUrl, imageView: storeLogo)
        }
        keepBuyingButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.keepBuyingPressed)))
        
        if let buttonColor = PaymentezSDK.shared.style?.buttonBackgroundColor {
            keepBuyingButton.backgroundColor = buttonColor
        }
        if let textColor = PaymentezSDK.shared.style?.textColor {
            storeName.textColor = textColor
            cartTitle.textColor = textColor
        }
        if let textColor = PaymentezSDK.shared.style?.buttonTextColor {
            keepBuyingText.textColor = textColor
        }
    }
    
    @objc func keepBuyingPressed() {
        delegate?.onKeepBuyingPressed()
    }
}
