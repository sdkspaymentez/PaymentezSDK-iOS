import Foundation
import UIKit

class Color {
    
    var color: UIColor?
    var name: String?
    
    init(name: String, color: UIColor) {
        self.color = color
        self.name = name
    }
    
    static func getColors() -> [Color] {
        var colors = [Color]()
        
        colors.append(Color(name: "Naranja", color: UIColor(named: "sdkOrange")!))
        colors.append(Color(name: "Rojo", color: UIColor(named: "sdkRed")!))
        colors.append(Color(name: "Azul", color: UIColor(named: "sdkBlue")!))
        colors.append(Color(name: "Verde", color: UIColor(named: "sdkGreen")!))
        colors.append(Color(name: "Negro", color: UIColor(named: "sdkBlack")!))
        colors.append(Color(name: "Blanco", color: UIColor(named: "sdkWhite")!))
        
        return colors
    }
    
}
