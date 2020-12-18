//
//  PmzStyle.swift
//  Alamofire
//
//  Created by Fennoma on 02/12/2020.
//

import Foundation

public class PmzStyle {
    var font: PmzFont = PmzFont.SYSTEM
    var backgroundColor: UIColor?
    var textColor: UIColor?
    var buttonBackgroundColor: UIColor?
    var buttonTextColor: UIColor?
    
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
    
    public func setFont(_ font: PmzFont) -> PmzStyle {
        self.font = font
        return self
    }
}
