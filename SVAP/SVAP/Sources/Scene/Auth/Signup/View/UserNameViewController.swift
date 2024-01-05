import UIKit
import RxSwift
import RxCocoa
import Moya

class UserNameViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    private let viewModel = UserNameViewModel()
    
    private let logoImage = UIImageView(image: UIImage(named: "shadowLogo"))
    private let signupLabel = UILabel().then {
        $0.text = "회원가입"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
    }
    private let progressLabel = UILabel().then {
        $0.text = "3/3"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
    }
    private let nameTextField = CustomTextField(placeholder: "이름 (2~5자)", isSecure: false).then {
        $0.keyboardType = .default
    }
    private let nameDuplicationLabel = UILabel().then {
        $0.textColor = .red
    }
    private let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.backgroundColor = .clear
        $0.spacing = 4
    }
    private let signupButton = CustomButton(type: .system, title: "회원가입", titleColor: .white, backgroundColor: UIColor(named: "main-4")!)
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
    }
    override func configureUI() {
        [
            logoImage,
            signupLabel,
            progressLabel,
            nameTextField,
            nameDuplicationLabel,
            loginStackView,
            buttonStackView
        ].forEach({ view.addSubview($0) })
        [loginLabel, loginButton].forEach({ loginStackView.addArrangedSubview($0) })
        [signupButton, loginStackView].forEach({ buttonStackView.addArrangedSubview($0) })
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
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(signupLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(45)
            $0.height.equalTo(50)
        }
        nameDuplicationLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(45)
        }
        signupButton.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(36)
            $0.left.right.equalToSuperview().inset(45)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        let signup = SignupInfo.shared
        let input = UserNameViewModel.Input(
            signup: signup,
            doneTap: signupButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input)
        
        output.signupResult.subscribe(onNext: { [weak self] bool in
            if bool {
                print("Success")
                self?.pushViewController(TabBarVC())
            } else {
                print("Fail")
            }
        }).disposed(by: disposeBag)
        
    }
    
    override func subscribe() {
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.pushViewController(LoginViewController())
            }).disposed(by: disposeBag)
        
        nameTextField.rx.text
            .subscribe(onNext: { [weak self] text in
                if text!.isEmpty {
                    self?.nameTextField.layer.borderColor(UIColor(named: "gray-300")!)
                    self?.signupButton.backgroundColor = UIColor(named: "main-4")
                    self?.signupButton.isEnabled = false
                } else{
                    SignupInfo.shared.userName.accept(self?.nameTextField.text)
                    self?.nameTextField.layer.borderColor(UIColor(named: "main-2")!)
                    self?.signupButton.backgroundColor = UIColor(named: "main-2")
                    self?.signupButton.isEnabled = true
                }
            }).disposed(by: disposeBag)
        
    }
    
}

extension UserNameViewController {
    
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
}
