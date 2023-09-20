import UIKit
import SnapKit
import Then

class LoginViewController: BaseVC, UITextFieldDelegate {
    
    private var eyeButton = UIButton(type: .custom)
    private let logoImage = UIImageView(image: UIImage(named: "shadowLogo"))
    private let loginLabel = UILabel().then {
        $0.text = "로그인"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
    }
    private let idTextField = CustomTextField(placeholder: "아이디", isSecure: false).then {
        $0.keyboardType = .alphabet
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
    }
    private let passwordTextField = CustomTextField(placeholder: "비밀번호", isSecure: true).then {
        $0.keyboardType = .alphabet
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
    }
    private let loginStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
        $0.backgroundColor = .clear
    }
    private let loginButton = CustomButton(type: .system, title: "로그인", titleColor: .white, backgroundColor: UIColor(named: "main-4")!).then {
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(clickLoginButton), for: .touchUpInside)
    }
    private let signupStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
        $0.backgroundColor = .clear
    }
    private let signupQuestionLabel = UILabel().then {
        $0.text = "아직 가입하지 않으셨나요?"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    private let userSignupButton = LabelButton(type: .system, title: "회원가입", titleColor: UIColor(named: "main-1")!).then {
        $0.addTarget(self, action: #selector(moveUserSignupView), for: .touchUpInside)
    }
    private let orLabel = UILabel().then {
        $0.text = "또는"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    private let adminSignupButton = LabelButton(type: .system, title: "관리자용 회원가입", titleColor: UIColor(named: "main-1")!).then {
        $0.addTarget(self, action: #selector(moveAdminSignupView), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setupKeyboardObservers()
        showPasswordButton()
        idTextField.delegate = self
        passwordTextField.delegate = self
    }
    override func configureUI() {
        super.configureUI()
        [
            logoImage,
            loginLabel,
            idTextField,
            passwordTextField,
            signupStackView,
            loginStackView
        ].forEach({ view.addSubview($0) })
        [signupQuestionLabel, userSignupButton, orLabel, adminSignupButton].forEach({
            signupStackView.addArrangedSubview($0)
        })
        [loginButton, signupStackView].forEach({ loginStackView.addArrangedSubview($0) })
    }
    override func setConstraints() {
        super.setConstraints()
        
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(139)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(126)
            $0.height.equalTo(45)
        }
        loginLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(73)
            $0.left.equalToSuperview().inset(45)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(50)
        }
        loginButton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        loginStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(36)
            $0.left.right.equalToSuperview().inset(45)
        }
    }
    
    @objc func clickLoginButton() {
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
    @objc func moveUserSignupView() {
        self.navigationController?.pushViewController(UserIdViewController(), animated: true)
    }
    @objc func moveAdminSignupView() {
        self.navigationController?.pushViewController(AdminCodeViewController(), animated: true)
    }
}

extension LoginViewController {
    
    private func showPasswordButton() {
        eyeButton = UIButton.init (primaryAction: UIAction (handler: { [self]_ in
            passwordTextField.isSecureTextEntry.toggle()
            self.eyeButton.isSelected.toggle()
        }))
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.baseBackgroundColor = .clear
        eyeButton.setImage (UIImage (named: "closeEye"), for: .normal)
        self.eyeButton.setImage(UIImage (named: "openEye"), for: .selected)
        self.eyeButton.configuration = buttonConfiguration
        self.passwordTextField.rightView = eyeButton
        self.passwordTextField.rightViewMode = .always
    }
    
    private func setupKeyboardObservers() {
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
      }
      private func removeKeyboardObservers() {
          NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
      }
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                self.loginStackView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 35)
            }
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.loginStackView.transform = .identity
        }
    }
    @objc private func textFieldDidChange(_ textfield: UITextField) {
        guard let id = idTextField.text,
              let password = passwordTextField.text,
                !(id.isEmpty || password.isEmpty)
        else {
            loginButton.backgroundColor = UIColor(named: "main-4")
            loginButton.isEnabled = false
            return
        }
        loginButton.backgroundColor = UIColor(named: "main-2")
        loginButton.isEnabled = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == idTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
