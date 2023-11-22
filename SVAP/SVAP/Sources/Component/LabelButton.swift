import UIKit

class LabelButton: UIButton {
    private func setup(title: String, titleColor: UIColor) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = .clear
        self.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    
    convenience init(type: UIButton.ButtonType, title: String, titleColor: UIColor) {
        self.init(type: type)
        setup(title: title, titleColor: titleColor)
    }
}
