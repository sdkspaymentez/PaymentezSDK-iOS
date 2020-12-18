//
//  ProductConfigurationItemCellView.swift
//  Alamofire
//
//  Created by Fennoma on 11/12/2020.
//

import Foundation

protocol ProductConfigurationItemDelegate {
    func onItemSelected(product: PmzProductConfiguration, cell: ProductConfigurationItemCellView, position: Int)
}

class ProductConfigurationItemCellView: UITableViewCell {
    
    @IBOutlet var container: UIView!
    @IBOutlet var checkbox: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var price: UILabel!
    
    var item: PmzProductConfiguration?
    var index: Int?
    
    var delegate: ProductConfigurationItemDelegate?
    
    func configure(item: PmzProductConfiguration, position: Int) {
        self.item = item
        self.index = position
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onItemClicked)))
        setPropperImage(item.isChecked())
        label.text = item.name
        price.text = "+" + CurrencyUtils.getPrice(item.extraPrice)
    }
    
    @objc func onItemClicked() {
        if let item = self.item, let position = index {
            delegate?.onItemSelected(product: item, cell: self, position: position)
        }
    }
    
    func setPropperImage(_ checked: Bool) {
        if checked {
            checkbox.image = UIImage(named: "checkbox_checked", in: PaymentezSDK.shared.getBundle(), compatibleWith: nil)
            if let color = PaymentezSDK.shared.style?.buttonBackgroundColor {
                checkbox.tintColor = color
            }
        } else {
            checkbox.image = UIImage(named: "checkbox_unchecked", in: PaymentezSDK.shared.getBundle(), compatibleWith: nil)
            if let grayColor = UIColor(named: "unselected_gray", in: PaymentezSDK.shared.getBundle(), compatibleWith: nil) {
                checkbox.tintColor = grayColor
            }
        }
    }
}
