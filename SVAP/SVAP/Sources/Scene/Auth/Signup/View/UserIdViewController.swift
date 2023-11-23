import UIKit
import RxSwift
import RxCocoa

class UserIdViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    private let viewModel = UserIdViewModel()
    
    private let logoImage = UIImageView(image: UIImage(named: "shadowLogo"))
    private let signupLabel = UILabel().then {
        $0.text = "회원가입"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
    }
    private let progressLabel = UILabel().then {
        $0.text = "1/3"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
    }
    private let idTextField = CustomTextField(placeholder: "아이디 (5~16자)", isSecure: false)
    private let idDuplicationLabel = UILabel().then {
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
        textFieldDidChange()
    }
    override func configureUI() {
        [
            logoImage,
            signupLabel,
            progressLabel,
            idTextField,
            idDuplicationLabel,
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
        idTextField.snp.makeConstraints {
            $0.top.equalTo(signupLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(50)
        }
        idDuplicationLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(5)
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
    override func bind() {
        let input = UserIdViewModel.Input(id: idTextField.rx.text.orEmpty.asDriver(),
                                          doneTap: nextButton.rx.tap.asSignal())
        let output = viewModel.transform(input)
        
        output.result.subscribe(onNext: { bool in
            if bool {
                SignupInfo.shared.accountId.accept(self.idTextField.text)
                self.pushViewController(UserPasswordViewController())
            } else {
                self.idDuplicationLabel.text = "아이디를 확인해주세요"//멘트 바꿀까
            }
        }).disposed(by: disposeBag)
    }
    
    override func subscribe() {
        loginButton.rx.tap
            .subscribe(onNext: {
                self.pushViewController(LoginViewController())
            }).disposed(by: disposeBag)
    }
    
}

extension UserIdViewController {
    
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
    func textFieldDidChange() {
        idTextField.rx.text
            .subscribe(onNext: { text in
                if text!.isEmpty {
                    self.idTextField.layer.borderColor(UIColor(named: "gray-300")!)
                    self.nextButton.backgroundColor = UIColor(named: "main-4")
                    self.nextButton.isEnabled = false
                } else {
                    self.idTextField.layer.borderColor(UIColor(named: "main-2")!)
                    self.nextButton.backgroundColor = UIColor(named: "main-2")
                    self.nextButton.isEnabled = true
                    self.idDuplicationLabel.text = nil
                }
            }).disposed(by: disposeBag)
    }
    
}
