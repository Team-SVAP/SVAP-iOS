import UIKit
import RxSwift
import RxCocoa
import Moya

class LoginViewController: BaseVC, UITextFieldDelegate {
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    private var eyeButton = UIButton(type: .custom)
    private let logoImage = UIImageView(image: UIImage(named: "shadowLogo"))
    private let loginLabel = UILabel().then {
        $0.text = "로그인"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
    }
    private let idTextField = CustomTextField(placeholder: "아이디", isSecure: false).then {
        $0.textContentType = .password
    }
    private let passwordTextField = CustomTextField(placeholder: "비밀번호", isSecure: true)
    private let loginFailLabel = UILabel().then {
        $0.textColor = .systemRed
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    private let loginStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
        $0.backgroundColor = .clear
    }
    private let loginButton = CustomButton(type: .system, title: "로그인", titleColor: .white, backgroundColor: UIColor(named: "main-4")!)
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
    private let signupButton = LabelButton(type: .system, title: "회원가입", titleColor: UIColor(named: "main-1")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObservers()
        showPasswordButton()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func configureUI() {
        super.configureUI()
        [
            logoImage,
            loginLabel,
            idTextField,
            passwordTextField,
            loginFailLabel,
            signupStackView,
            loginStackView
        ].forEach({ view.addSubview($0) })
        [signupQuestionLabel, signupButton].forEach({ signupStackView.addArrangedSubview($0) })
        [loginButton, signupStackView].forEach({ loginStackView.addArrangedSubview($0) })
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(139)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(126)
            $0.height.equalTo(55)
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
        loginFailLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(5)
            $0.left.equalToSuperview().inset(45)
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
    
    override func bind() {
        let input = LoginViewModel.Input(
            id: idTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            doneTap: loginButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input)
        
        output.result.subscribe(onNext: { bool in
            if bool {
                self.pushViewController(TabBarVC())
            } else {
                self.loginFailLabel.text = "아이디 또는 비밀번호를 확인하세요."
            }
        }).disposed(by: disposeBag)
    }
    
    override func subscribe() {
        super.subscribe()
        
        let textField = Observable.combineLatest(idTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty)
        textField
            .map{ $0.count != 0 && $1.count != 0 }
            .subscribe(onNext: { change in
                self.loginButton.isEnabled = change
                switch change {
                    case true:
                        self.loginButton.backgroundColor = UIColor(named: "main-2")
                    case false:
                        self.loginButton.backgroundColor = UIColor(named: "main-4")
                }
            }).disposed(by: disposeBag)
        
        idTextField.rx.text.orEmpty
            .subscribe(onNext: {
                if $0.isEmpty {
                    self.idTextField.layer.borderColor(UIColor(named: "gray-300")!)
                } else {
                    self.idTextField.layer.borderColor(UIColor(named: "main-2")!)
                }
            }).disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .subscribe(onNext: {
                if $0.isEmpty {
                    self.passwordTextField.layer.borderColor(UIColor(named: "gray-300")!)
                } else {
                    self.passwordTextField.layer.borderColor(UIColor(named: "main-2")!)
                }
            }).disposed(by: disposeBag)
        
        signupButton.rx.tap
            .subscribe(onNext: {
                self.pushViewController(UserIdViewController())
            }).disposed(by: disposeBag)
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
    //리팩하기
    
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == idTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
