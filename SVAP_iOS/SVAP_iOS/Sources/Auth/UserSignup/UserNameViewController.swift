import UIKit
import SnapKit
import Then

class UserNameViewController: BaseVC {
    
    private let logoImage = UIImageView(image: UIImage(named: "shadowLogo"))
    private let signupLabel = UILabel().then {
        $0.text = "회원가입"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
    }
    private let progressLabel = UILabel().then {
        $0.text = "3/4"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
    }
    private let nameTextField = CustomTextField(placeholder: "이름", isSecure: false)
    private let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.backgroundColor = .clear
        $0.spacing = 4
    }
    private let nextButton = CustomButton(type: .system, title: "다음", titleColor: .white, backgroundColor: UIColor(named: "main-4")!).then {
        $0.addTarget(self, action: #selector(moveNetxView), for: .touchUpInside)
    }
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
    private let loginButton = LabelButton(type: .system, title: "로그인", titleColor: UIColor(named: "main-1")!).then {
        $0.addTarget(self, action: #selector(moveLoginView), for: .touchUpInside)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setupKeyboardObservers()
    }
    override func configureUI() {
        [
            logoImage,
            signupLabel,
            progressLabel,
            nameTextField,
            loginStackView,
            buttonStackView
        ].forEach({ view.addSubview($0) })
        [loginLabel, loginButton].forEach({ loginStackView.addArrangedSubview($0) })
        [nextButton, loginStackView].forEach({ buttonStackView.addArrangedSubview($0) })
    }
    override func setConstraints() {
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(139)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(126)
            $0.height.equalTo(45)
        }
        signupLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(73)
            $0.left.equalToSuperview().inset(45)
        }
        progressLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(73)
            $0.right.equalToSuperview().inset(45)
        }
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(signupLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(50)
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
                self.buttonStackView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 35)
            }
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.buttonStackView.transform = .identity
        }
    }
    @objc private func moveNetxView() {
        self.navigationController?.pushViewController(UserEmailViewController(), animated: true)
    }
    @objc func moveLoginView() {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }

}
