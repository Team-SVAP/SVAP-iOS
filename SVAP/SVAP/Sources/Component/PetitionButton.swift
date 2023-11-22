import UIKit
import SnapKit
import Then

class PetitionButton: UIButton {
    
    private func buttonSetup(title: String, image: UIImage) {
        self.setTitle(title, for: .normal)
        self.setImage(image, for: .normal)
        self.semanticContentAttribute = .forceRightToLeft
        self.imageEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        self.tintColor = UIColor(named: "gray-700")
        self.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 16)
        self.backgroundColor = .white
        self.layer.borderColor = UIColor(named: "gray-100")?.cgColor
        self.layer.borderWidth = 0.5
        self.layer.shadowOpacity = 1
        self.layer.cornerRadius = 24
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        self.layer.shadowColor = UIColor(named: "gray-200")?.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 2
    }
    convenience init(type: UIButton.ButtonType, title: String, image: UIImage) {
        self.init(type: type)
        buttonSetup(title: title, image: image)
    }
}
