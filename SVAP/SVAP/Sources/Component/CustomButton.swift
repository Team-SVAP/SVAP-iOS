import UIKit

class CustomButton: UIButton {
    private func setup(title: String, titleColor: UIColor, backgroundColor: UIColor) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 20)
        self.layer.cornerRadius = 12
        self.isEnabled = false
    }
    
    convenience init(type: UIButton.ButtonType, title: String, titleColor: UIColor, backgroundColor: UIColor) {
        self.init(type: type)
        setup(title: title, titleColor: titleColor, backgroundColor: backgroundColor)
    }
}
