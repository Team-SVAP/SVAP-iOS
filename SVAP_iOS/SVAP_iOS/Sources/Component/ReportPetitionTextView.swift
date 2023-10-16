import UIKit
import SnapKit
import Then

class ReportPetitionTextView: UITextView {
    
    init(
        
    ) {
        super.init(frame: .zero, textContainer: .none)
        self.textContainer.maximumNumberOfLines = 0
        self.textColor = UIColor(named: "gray-500")
        self.font = UIFont(name: "IBMPlexSansKR-Regular", size: 8)
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        self.layer.borderWidth = 1
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
