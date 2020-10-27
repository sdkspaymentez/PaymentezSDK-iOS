//
//  PmzStyle.swift
//  PaymentezSDK
//
//  Created by Fennoma on 27/10/2020.
//

import Foundation

public class PmzStyle {
    
    public var backgroundColor: UIColor?
    public var textColor: UIColor?
    public var buttonBackgroundColor: UIColor?
    public var buttonTextColor: UIColor?
    
    public init(){}
    
    public func setBackgroundColor(_ backgroundColor: UIColor) -> PmzStyle {
        self.backgroundColor = backgroundColor
        return self
    }
    
    public func setTextColor(_ textColor: UIColor) -> PmzStyle {
        self.textColor = textColor
        return self
    }
    
    public func setButtonBackgroundColor(_ buttonBackgroundColor: UIColor) -> PmzStyle {
        self.buttonBackgroundColor = buttonBackgroundColor
        return self
    }
    
    public func setButtonTextColor(_ buttonTextColor: UIColor) -> PmzStyle {
        self.buttonTextColor = buttonTextColor
        return self
    }
}
