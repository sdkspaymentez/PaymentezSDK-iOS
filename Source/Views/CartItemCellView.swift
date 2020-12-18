//
//  CartItemCellView.swift
//  Alamofire
//
//  Created by Fennoma on 16/12/2020.
//

import Foundation

class CartItemCellView: UITableViewCell {
    
    @IBOutlet var container: UIView!
    @IBOutlet var img: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var content: UILabel!
    @IBOutlet var price: UILabel!
    
    func configure(item: PmzItem) {
        PmzImageUtils.loadImage(item.imageUrl, imageView: img)
        name.text = item.productName
        content.text = generateContent(configs: item.configurations)
        var amount: Double = 1
        if let realAmount = item.quantity {
            amount = Double(realAmount)
        }
        var priceToMultiply: Double = 0
        if let pricePerUnit = item.totalAmount {
            priceToMultiply = pricePerUnit
        }
        price.text = CurrencyUtils.getPrice(priceToMultiply * amount)
    }
    
    func generateContent(configs: [PmzConfiguration]?) -> String {
        var result = ""
        if let configs = configs {
            for config in configs {
                if let desc = config.description {
                    if result != "" {
                        result = result + "\n"
                    }
                    result = result + "+ " + desc
                }
            }
        }
        return result
    }
}
