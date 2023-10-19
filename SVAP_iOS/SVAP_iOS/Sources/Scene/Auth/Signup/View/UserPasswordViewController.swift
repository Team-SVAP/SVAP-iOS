import UIKit
import RxSwift
import RxCocoa

class UserPasswordViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    
    private var eyeButton = UIButton(type: .custom)
    private var checkEyeButton = UIButton(type: .custom)
    private let logoImage = UIImageView(image: UIImage(named: "shadowLogo"))
    private let signupLabel = UILabel().then {
        $0.text = "회원가입"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
    }
    private let progressLabel = UILabel().then {
        $0.text = "2/3"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
    }
    private let passwordTextField = CustomTextField(placeholder: "비밀번호 (특수문자 포함 8~32자 )", isSecure: true).then {
        $0.becomeFirstResponder()
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
    }
    private let passwordValidTextField = CustomTextField(placeholder: "비밀번호 확인", isSecure: true).then {
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
    }
    private let passwordValidLabel = UILabel().then {
        $0.textColor = .systemRed
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    private let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.backgroundColor = .clear
        $0.spacing = 4
    }
    private let nextButton = CustomButton(type: .system, title: "다음", titleColor: .white, backgroundColor: UIColor(named: "main-4")!)
    private let loginStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.backgroundColor = .clear
        $0.alignment = .center
    }
    private let loginLabel = UILabel().then {
        $0.text = "이미 가입하셨나요?"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    private let loginButton = LabelButton(type: .system, title: "로그인", titleColor: UIColor(named: "main-1")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObservers()
        showPasswordButton()
        showPasswordCheckButton()
    }
    override func configureUI() {
        [
            logoImage,
            signupLabel,
            progressLabel,
            passwordTextField,
            passwordValidTextField,
            passwordValidLabel,
            loginStackView,
            buttonStackView
        ].forEach({ view.addSubview($0) })
        [loginLabel, loginButton].forEach({ loginStackView.addArrangedSubview($0) })
        [nextButton, loginStackView].forEach({ buttonStackView.addArrangedSubview($0) })
    }
    override func setupConstraints() {
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(139)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(126)
            $0.height.equalTo(55)
        }
        signupLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(63)
            $0.left.equalToSuperview().inset(45)
        }
        progressLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(63)
            $0.right.equalToSuperview().inset(45)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(signupLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(50)
        }
        passwordValidTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(50)
        }
        passwordValidLabel.snp.makeConstraints {
            $0.top.equalTo(passwordValidTextField.snp.bottom).offset(5)
            $0.left.equalToSuperview().inset(45)
        }
        nextButton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(36)
            $0.left.right.equalToSuperview().inset(45)
        }
        
    }
    
    override func subscribe() {
        super.subscribe()
        
        nextButton.rx.tap
            .subscribe(onNext: {
                self.pushViewController(UserNameViewController())
            }).disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: {
                self.pushViewController(LoginViewController())
            }).disposed(by: disposeBag)
    }
}

extension UserPasswordViewController {
    
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
    private func showPasswordCheckButton() {
        checkEyeButton = UIButton.init (primaryAction: UIAction (handler: { [self]_ in
            passwordValidTextField.isSecureTextEntry.toggle()
            self.checkEyeButton.isSelected.toggle ()
        }))
        var buttonConfiguration2 = UIButton.Configuration.plain()
        buttonConfiguration2.imagePadding = 10
        buttonConfiguration2.baseBackgroundColor = .clear
        checkEyeButton.setImage (UIImage (named: "closeEye"), for: .normal)
        self.checkEyeButton.setImage(UIImage (named: "openEye"), for: .selected)
        self.checkEyeButton.configuration = buttonConfiguration2
        self.passwordValidTextField.rightView = checkEyeButton
        self.passwordValidTextField.rightViewMode = .always
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
                self.buttonStackView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 39)
            }
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.buttonStackView.transform = .identity
        }
    }
    @objc private func textFieldDidChange(_ textfield: UITextField) {
        
        if textfield.hasText {
            textfield.layer.borderColor = UIColor(named: "main-2")?.cgColor
        } else {
            textfield.layer.borderColor = UIColor(named: "gray-300")?.cgColor
        }
        
        guard let password = passwordTextField.text,
              let passwordValid = passwordValidTextField.text,
              !(password.isEmpty || passwordValid.isEmpty) && password == passwordValid
        else {
            nextButton.backgroundColor = UIColor(named: "main-4")
            nextButton.isEnabled = false
            passwordValidLabel.text = "비밀번호를 다시 확인해주세요."
            return
        }
        passwordValidLabel.text = ""
        nextButton.backgroundColor = UIColor(named: "main-2")
        nextButton.isEnabled = true
    }
}