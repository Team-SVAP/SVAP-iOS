import UIKit
import SnapKit
import Then

class StartViewController: BaseVC {
    
    private let logoImage = UIImageView(image: UIImage(named: "logo"))
    private let loginButton = CustomButton(type: .system, title: "로그인", titleColor: UIColor(named: "gray-700")!, backgroundColor: UIColor(named: "main-6")!).then {
        $0.addTarget(self, action: #selector(moveLoginView), for: .touchUpInside)
    }
    private let signupButton = CustomButton(type: .system, title: "회원가입", titleColor: UIColor(named: "gray-700")!, backgroundColor: .white).then {
        $0.layer.borderColor = UIColor(named: "main-6")?.cgColor
        $0.layer.borderWidth = 1
        $0.addTarget(self, action: #selector(moveUserSignupView), for: .touchUpInside)
    }
    private let signupStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    private let adminSignupLabel = UILabel().then {
        $0.text = "혹시 관리자이신가요?"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Regular", size: 12)
    }
    private let adminSignupButton = UIButton(type: .system).then {
        $0.backgroundColor = .clear
        $0.setTitle("관리자용 회원가입", for: .normal)
        $0.setTitleColor(UIColor(named: "main-1"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Regular", size: 12)
        $0.addTarget(self, action: #selector(moveAdminSignupView), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configureUI() {
        [
            logoImage,
            loginButton,
            signupButton,
            signupStackView
        ].forEach({ view.addSubview($0) })
        [adminSignupLabel, adminSignupButton].forEach({ signupStackView.addArrangedSubview($0) })
    }
    override func setConstraints() {
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(208)
            $0.left.right.equalToSuperview().inset(45)
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(128)
            $0.left.right.equalToSuperview().inset(35)
            $0.height.equalTo(60)
        }
        signupButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(35)
            $0.height.equalTo(60)
        }
        signupStackView.snp.makeConstraints {
            $0.top.equalTo(signupButton.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func moveLoginView() {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    @objc func moveUserSignupView() {
        self.navigationController?.pushViewController(UserIdViewController(), animated: true)
    }
    @objc func moveAdminSignupView() {
        self.navigationController?.pushViewController(AdminIdViewController(), animated: true)
    }
}
