import Foundation
import UIKit

extension CALayer {
    
    func borderColor(_ color: UIColor) {
        self.borderColor = color.cgColor
    }
    
    func border(_ color: UIColor, _ width: CGFloat) {
        self.borderColor = color.cgColor
        self.borderWidth = width
    }
    
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        self.cornerRadius = cornerRadius
        self.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
    
    func shadow(
        color: UIColor,
        alpha: Float,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat,
        spread: CGFloat
    ) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / UIScreen.main.scale
        if spread == 0 {
            shadowPath = nil
        } else {
            let rect = bounds.insetBy(dx: -spread, dy: -spread)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
}
