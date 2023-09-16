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
            passwordTextField
        ].forEach({ view.addSubview($0) })
    }
    override func setConstraints() {
        super.setConstraints()
        
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(139)
            $0.left.right.equalToSuperview().inset(132)
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
    }
}
