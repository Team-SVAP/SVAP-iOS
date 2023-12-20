import UIKit
import RxSwift
import RxCocoa

class PasswordChangeViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    private let viewModel = PetitionCreateViewModel()
    private let successSignal = PublishRelay<Void>()
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "비밀번호 변경"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let leftButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "leftArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let rightButton = UIButton(type: .system).then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-600"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 16)
    }
    private let newPasswordLabel = UILabel().then {
        $0.text = "새로운 비밀번호"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let passwordTextField = SearchTextField(placeholder: "").then {
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 8
    }
    private let passwordCheckLabel = UILabel().then {
        $0.text = "비밀번호 확인"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let passwordCheckTextField = SearchTextField(placeholder: "").then {
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        navigationBarSetting()
    }
    override func configureUI() {
        super.configureUI()
        
        [
            newPasswordLabel,
            passwordTextField,
            passwordCheckLabel,
            passwordCheckTextField
        ].forEach({ view.addSubview($0) })
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        newPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.left.equalToSuperview().inset(20)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(newPasswordLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        passwordCheckLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(16)
            $0.left.equalToSuperview().inset(20)
        }
        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(passwordCheckLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
    }
    override func subscribe() {
        super.subscribe()
        
        leftButton.rx.tap
            .subscribe(onNext: {
                self.popViewController()
            }).disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .subscribe(onNext: {
                if $0.isEmpty {
                    self.passwordTextField.layer.borderColor(UIColor(named: "gray-400")!)
                } else {
                    self.passwordTextField.layer.borderColor(UIColor(named: "main-1")!)
                }
            }).disposed(by: disposeBag)
        
        passwordCheckTextField.rx.text.orEmpty
            .subscribe(onNext: {
                if $0.isEmpty {
                    self.passwordCheckTextField.layer.borderColor(UIColor(named: "gray-400")!)
                } else {
                    self.passwordCheckTextField.layer.borderColor(UIColor(named: "main-1")!)
                }
            }).disposed(by: disposeBag)
        
        let text = Observable.combineLatest(passwordTextField.rx.text, passwordCheckTextField.rx.text)
        text.subscribe(onNext: {
            if ($0!.count != 0 && $1!.count != 0) {
                self.rightButton.isEnabled = true
                self.rightButton.setTitleColor(UIColor(named: "main-1"), for: .normal)
            } else {
                self.rightButton.isEnabled = false
                self.rightButton.setTitleColor(UIColor(named: "gray-600"), for: .normal)
            }
        }).disposed(by: disposeBag)
        
    }
    
    func navigationBarSetting() {
        navigationItem.titleView = navigationTitleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
}
