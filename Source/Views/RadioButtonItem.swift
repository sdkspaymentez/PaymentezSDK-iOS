//
//  RadioButtonItem.swift
//  Alamofire
//
//  Created by Fennoma on 11/12/2020.
//

import Foundation

class RadioButtonItem: UIView {
    
    @IBOutlet var label: UILabel!
    
    func configure(config: PmzProductConfiguration) {
        label.text = config.name
    }
}
