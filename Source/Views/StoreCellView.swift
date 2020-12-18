//
//  StoreItemView.swift
//  PaymentezSDK
//
//  Created by Fennoma on 02/12/2020.
//

import Foundation

protocol StoreDelegate {
    func itemSelected(_ store: PmzStore)
}

public class StoreCellView: UITableViewCell {
    
    @IBOutlet var container: CardView!
    @IBOutlet var headerImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var logo: UIImageView!
    @IBOutlet var logoContainer: UIView!
    @IBOutlet var distance: UILabel!
    
    var store: PmzStore?
    var delegate: StoreDelegate?
    
    func configure(store: PmzStore) {
        self.store = store
        setImageCorners()
        PmzImageUtils.loadImage(store.imageUrl, imageView: headerImage)
        PmzImageUtils.loadImage(store.imageUrl, imageView: logo)
        
        logoContainer.clipsToBounds = true
        logoContainer.layer.masksToBounds = true
        logoContainer.layer.cornerRadius = 26
        
        logo.layer.borderWidth = 5
        logo.layer.borderColor = UIColor.white.cgColor
        
        title.text = store.name
        subtitle.text = store.commerceName
        
        if let style = PaymentezSDK.shared.style, let textColor = style.textColor {
            title.textColor = textColor
            subtitle.textColor = textColor
        }
        
        container.setCornerRadius(cornerRadius: 10)
        
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapContainer)))
    }
    
    func setImageCorners() {
        headerImage.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
    
    @objc func didTapContainer() {
        if let storeToSend = store {
            delegate?.itemSelected(storeToSend)
        }
    }
}
