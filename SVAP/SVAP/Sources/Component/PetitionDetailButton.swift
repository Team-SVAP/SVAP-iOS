import UIKit

class PetitionDetailButton: UIButton {
    
    func setup(title: String, titleColor: UIColor, backgroundColor: UIColor) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.borderColor = UIColor(named: "main-2")?.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    convenience init(type: UIButton.ButtonType, title: String, titleColor: UIColor, backgroundColor: UIColor) {
        self.init(type: type)
        setup(title: title, titleColor: titleColor, backgroundColor: backgroundColor)
    }
    
}
