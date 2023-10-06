import UIKit
import SnapKit
import Then

class CustomTextView: UITextView {
    
    init(
        
    ) {
        super.init(frame: .zero, textContainer: .none)
        self.textContainer.maximumNumberOfLines = 1
        self.textColor = UIColor(named: "gray-800")
        self.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        self.layer.borderWidth = 0.5
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.textContainerInset = UIEdgeInsets(top: 14, left: 10, bottom: 0, right: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
