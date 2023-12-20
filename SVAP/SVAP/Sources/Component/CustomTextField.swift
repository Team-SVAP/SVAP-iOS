import UIKit

class CustomTextField: UITextField {
    
    private var placeholderText: String = ""

    init(
        placeholder: String,
        isSecure: Bool
    ) {
        super.init(frame: .zero)
        self.isSecureTextEntry = isSecure
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.keyboardType = .alphabet
        self.placeholderText = placeholder
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.textColor = UIColor(named: "gray-800")
        self.font = UIFont(name: "IBMPlexSansKR-Medium", size: 16)
        self.layer.borderColor = UIColor(named: "gray-300")?.cgColor
        self.layer.borderWidth = 0.5
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        self.leftView = spacerView
        self.rightView = spacerView
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
                NSAttributedString.Key.foregroundColor: UIColor(named: "gray-400")!,
                NSAttributedString.Key.font: UIFont(name: "IBMPlexSansKR-Medium", size: 16)!
            ]
        )
    }

}
