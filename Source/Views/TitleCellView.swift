//
//  TitleCellView.swift
//  Alamofire
//
//  Created by Fennoma on 11/12/2020.
//

import Foundation

class TitleCellView: UITableViewCell {
    
    @IBOutlet var titleView: UILabel!
    
    func configure(title: PmzTitleItem) {
        titleView.text = title.title
    }
}
