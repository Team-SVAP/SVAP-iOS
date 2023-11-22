import UIKit

class SearchTextField: UITextField {
    
    private var placeholderText: String = ""

    init(
        placeholder: String
    ) {
        super.init(frame: .zero)
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.placeholderText = placeholder
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.textColor = UIColor(named: "gray-700")
        self.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
        self.layer.borderColor = UIColor(named: "main-3")?.cgColor
        self.layer.borderWidth = 1
        let leftSpacerView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        let rightSpacerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 0))
        self.leftView = leftSpacerView
        self.rightView = rightSpacerView
        self.leftViewMode = .always
        self.rightViewMode = .always
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderSetting()
    }
    
    func placeholderSetting() {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "gray-300")!,
                NSAttributedString.Key.font: UIFont(name: "IBMPlexSansKR-Regular", size: 12)!
            ]
        )
    }

}
