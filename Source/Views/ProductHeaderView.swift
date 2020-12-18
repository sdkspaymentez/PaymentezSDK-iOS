//
//  ProductHeaderView.swift
//  Alamofire
//
//  Created by Fennoma on 15/12/2020.
//

import Foundation

class ProductHeaderView: UIView {
    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var price: UILabel!
    
    func configure(product: PmzProduct?) {
        if let product = product {
            name.text = product.name
            desc.text = product.description
            price.text = CurrencyUtils.getPrice(product.currentPrice)
            PmzImageUtils.loadImage(product.imageUrl, imageView: productImage)
        }
    }
    
}
