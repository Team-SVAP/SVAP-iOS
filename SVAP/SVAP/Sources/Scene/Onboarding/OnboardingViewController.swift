import UIKit
import RxSwift
import RxCocoa

class OnboardingViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    
    private let logoImage = UIImageView(image: UIImage(named: "logo"))
    private let loginButton = CustomButton(type: .system, title: "로그인", titleColor: UIColor(named: "gray-700")!, backgroundColor: .white).then {
        $0.isEnabled = true
        $0.layer.borderColor = UIColor(named: "main-6")?.cgColor
        $0.layer.borderWidth = 1
    }
    private let signupStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.backgroundColor = .clear
        $0.alignment = .center
    }
    private let signupLabel = UILabel().then {
        $0.text = "아직 회원이 아니신가요?"
        $0.textColor = UIColor(named: "gray-600")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    private let signupButton = LabelButton(type: .system, title: "회원가입하기", titleColor: UIColor(named: "main-1")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configureUI() {
        [
            logoImage,
            loginButton,
            signupStackView
        ].forEach({ view.addSubview($0) })
        [signupLabel, signupButton].forEach({ signupStackView.addArrangedSubview($0) })
    }
    override func setupConstraints() {
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(208)
            $0.left.right.equalToSuperview().inset(45)
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(56)
            $0.left.right.equalToSuperview().inset(35)
            $0.height.equalTo(60)
        }
        signupStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginButton.snp.bottom).offset(8)
        }
    }
    
    override func subscribe() {
        super.subscribe()
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.pushViewController(LoginViewController())
            }).disposed(by: disposeBag)
        
        signupButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.pushViewController(UserIdViewController())
            }).disposed(by: disposeBag)
    }

}
