import Foundation
import UIKit

extension CALayer {
    
    func border(_ color: UIColor, _ width: CGFloat) {
        self.borderColor = color.cgColor
        self.borderWidth = width
    }
}
