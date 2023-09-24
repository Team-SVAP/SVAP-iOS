import UIKit

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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configureUI() {
        [
            logoImage,
            loginButton,
            signupButton,
        ].forEach({ view.addSubview($0) })
    }
    override func setupConstraints() {
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
    }
    
    @objc func moveLoginView() {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    @objc func moveUserSignupView() {
        self.navigationController?.pushViewController(UserIdViewController(), animated: true)
    }
}
