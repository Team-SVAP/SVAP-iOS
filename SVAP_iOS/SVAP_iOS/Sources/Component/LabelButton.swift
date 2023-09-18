import UIKit

class LabelButton: UIButton {
    private func setup(title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor(named: "main-1"), for: .normal)
        self.backgroundColor = .clear
        self.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    
    convenience init(type: UIButton.ButtonType, title: String) {
        self.init(type: type)
        setup(title: title)
    }
}
