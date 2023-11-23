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
}
