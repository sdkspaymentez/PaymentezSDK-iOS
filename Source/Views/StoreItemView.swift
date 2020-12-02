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

class StoreViewCell: UITableViewCell {
    
    @IBOutlet var container: UIView!
    @IBOutlet var headerImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UIView!
    @IBOutlet var logo: UIImageView!
    @IBOutlet var distance: UILabel!
    
    var delegate: StoreDelegate?
    
    func configure(store: PmzStore) {
        if let imageUrl = store.imageUrl {
            //headerImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder_big_image"))
        }
    }
}
