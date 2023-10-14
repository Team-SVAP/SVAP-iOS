import UIKit

class PetitionTypeButton: UIButton {
    private func setup(title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor(named: "gray-400"), for: .normal)
        self.backgroundColor = .clear
        self.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 13)
    }
    
    convenience init(type: UIButton.ButtonType, title: String) {
        self.init(type: type)
        setup(title: title)
    }
}
