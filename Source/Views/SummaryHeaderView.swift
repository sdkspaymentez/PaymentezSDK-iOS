//
//  SummaryHeaderView.swift
//  Alamofire
//
//  Created by Fennoma on 17/12/2020.
//

import Foundation

class SummaryHeaderView: UIView {
    
    @IBOutlet var firstLine: UILabel!
    @IBOutlet var secondLine: UILabel!
    @IBOutlet var headerImage: UIImageView!
    @IBOutlet var logo: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var summaryTitle: UILabel!
    
    func configure(store: PmzStore?) {
        if let store = store {
            name.text = store.name
            desc.text = store.commerceName
            PmzImageUtils.loadImage(store.imageUrl, imageView: headerImage)
            PmzImageUtils.loadImage(store.imageUrl, imageView: logo)
        }
        if let textColor = PaymentezSDK.shared.style?.textColor {
            firstLine.textColor = textColor
            secondLine.textColor = textColor
            name.textColor = textColor
            desc.textColor = textColor
            summaryTitle.textColor = textColor
        }
    }
}
