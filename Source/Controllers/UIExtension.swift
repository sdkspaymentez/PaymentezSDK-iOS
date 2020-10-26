import Foundation

extension UIView {
    
    func addBottomShadow() {
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: -15,
                                    y: self.bounds.height - 15))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width + 45,
                                       y: self.bounds.height - 15))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width + 45,
                                       y: self.bounds.height + 4))
        shadowPath.addLine(to: CGPoint(x: -15,
                                       y: self.bounds.height + 4))
        shadowPath.close()
        
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.4
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func dropShadow(color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), opacity: Float = 1, offSet: CGSize = CGSize(width: -1, height: 1), radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func updateShadowOpacity(opacity: Float) {
        layer.shadowOpacity = opacity
    }
}

