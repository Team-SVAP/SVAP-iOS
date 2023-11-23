import UIKit
import SnapKit
import Then

class PetitionReportButton: UIButton {
    
    private func buttonSetup(title: String, titleColor: UIColor, backgroundColor: UIColor, borderColor: UIColor, borderWidth: CGFloat) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 20)
        self.backgroundColor = backgroundColor
        self.layer.border(borderColor, borderWidth)
        self.layer.cornerRadius = 8
    }
    convenience init(type: UIButton.ButtonType, title: String, titleColor: UIColor!, backgroundColor: UIColor!, borderColor: UIColor, borderWidth: CGFloat) {
        self.init(type: type)
        buttonSetup(title: title, titleColor: titleColor, backgroundColor: backgroundColor, borderColor: borderColor, borderWidth: borderWidth)
    }
}
