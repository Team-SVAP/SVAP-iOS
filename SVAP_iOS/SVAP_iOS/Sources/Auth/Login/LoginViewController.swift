import UIKit
import SnapKit
import Then

class LoginViewController: BaseVC {
    
    private let logoImage = UIImageView(image: UIImage(named: "shadowLogo"))
    private let loginLabel = UILabel().then {
        $0.text = "로그인"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
    }
    private let idTextField = CustomTextField(placeholder: "아이디", isSecure: false).then {
        $0.keyboardType = .alphabet
    }
    private let passwordTextField = CustomTextField(placeholder: "비밀번호", isSecure: true).then {
        $0.keyboardType = .alphabet
    }
    private let loginButton = CustomButton(type: .system, title: "로그인", titleColor: .white, backgroundColor: UIColor(named: "main-4")!)
    private let signupStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
        $0.backgroundColor = .clear
    }
    private let signupQuestionLabel = UILabel().then {
        $0.text = "아직 가입하지 않으셨나요? "
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    private let userSignupButton = UIButton(type: .system).then {
        $0.backgroundColor = .clear
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(UIColor(named: "main-1"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
        $0.addTarget(self, action: #selector(moveUserSignupView), for: .touchUpInside)
    }
    private let orLabel = UILabel().then {
        $0.text = " 또는 "
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    private let adminSignupButton = UIButton(type: .system).then {
        $0.backgroundColor = .clear
        $0.setTitle("관리자용 회원가입", for: .normal)
        $0.setTitleColor(UIColor(named: "main-1"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
        $0.addTarget(self, action: #selector(moveAdminSignupView), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    override func configureUI() {
        super.configureUI()
        [
            logoImage,
            loginLabel,
            idTextField,
            passwordTextField,
            loginButton,
            signupStackView
        ].forEach({ view.addSubview($0) })
        [signupQuestionLabel, userSignupButton, orLabel, adminSignupButton].forEach({
            signupStackView.addArrangedSubview($0)
        })
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
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(45)
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(74)
            $0.left.right.equalToSuperview().inset(45)
        }
        signupStackView.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func moveUserSignupView() {
        self.navigationController?.pushViewController(UserIdViewController(), animated: true)
    }
    @objc func moveAdminSignupView() {
        self.navigationController?.pushViewController(AdminIdViewController(), animated: true)
    }
}
