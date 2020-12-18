//
//  CurrencyUtils.swift
//  Alamofire
//
//  Created by Fennoma on 09/12/2020.
//

import Foundation

class CurrencyUtils {
    
    static func getPrice(_ price: Double?) -> String{
        var priceToConvert: Double = 0
        if price != nil {
            priceToConvert = price!
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return "$ " + numberFormatter.string(from: priceToConvert as NSNumber)!
    }
    
}
