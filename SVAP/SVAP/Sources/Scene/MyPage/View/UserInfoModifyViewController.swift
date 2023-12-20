import UIKit
import RxSwift
import RxCocoa

class UserInfoModifyViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    private let viewModel = PetitionCreateViewModel()
    private let successSignal = PublishRelay<Void>()
    
    private let navigationTitleLabel = UILabel().then {
        $0.text = "내 정보 수정"
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
    private let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let nameTextField = SearchTextField(placeholder: "").then {
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 8
    }
    private let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let idTextField = SearchTextField(placeholder: "").then {
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 8
    }
    private let passwordChageButton = LabelButton(type: .system, title: "비밀번호 변경", titleColor: UIColor(named: "gray-800")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        navigationBarSetting()
    }
    override func configureUI() {
        super.configureUI()
        
        [
            nameLabel,
            nameTextField,
            idLabel,
            idTextField,
            passwordChageButton
        ].forEach({ view.addSubview($0) })
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.left.equalToSuperview().inset(20)
        }
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        idLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(16)
            $0.left.equalToSuperview().inset(20)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        passwordChageButton.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }
        
    }
    override func subscribe() {
        super.subscribe()
        
        leftButton.rx.tap
            .subscribe(onNext: {
                self.popViewController()
            }).disposed(by: disposeBag)
        
        passwordChageButton.rx.tap
            .subscribe(onNext: {
                self.pushViewController(PasswordChangeViewController())
            }).disposed(by: disposeBag)
        
        nameTextField.rx.text.orEmpty
            .subscribe(onNext: {
                if $0.isEmpty {
                    self.nameTextField.layer.borderColor(UIColor(named: "gray-400")!)
                } else {
                    self.nameTextField.layer.borderColor(UIColor(named: "main-1")!)
                }
            }).disposed(by: disposeBag)
        
        idTextField.rx.text.orEmpty
            .subscribe(onNext: {
                if $0.isEmpty {
                    self.idTextField.layer.borderColor(UIColor(named: "gray-400")!)
                } else {
                    self.idTextField.layer.borderColor(UIColor(named: "main-1")!)
                }
            }).disposed(by: disposeBag)
        
        let text = Observable.combineLatest(nameTextField.rx.text, idTextField.rx.text)
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
